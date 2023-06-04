import ServiceLifecycle
import ExampleAsyncHTTP1Server
import SwiftMiddleware
import Logging
import NIOCore
import NIOPosix

@main
struct Application {
    @Sendable
    private static func handler<ResponseWriter, MiddlewareContext>(
        request: HTTPServerRequest, responseWriter: ResponseWriter, context: MiddlewareContext) async throws
    where ResponseWriter: HTTPServerResponseWriterProtocol {
        await responseWriter.setStatus(.ok)
        try await responseWriter.commit()
        
        for try await bodyPart in request.body {
            try await responseWriter.bodyPart(bodyPart)
        }
        
        try await responseWriter.complete()
    }
    
    
    static func main() async throws {
        let logger = Logger(label: "Application")
        let eventLoopGroup =
            MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        
        let stack = MiddlewareStack {
            ExampleMiddleware<Void>()
        }
        
        let server = AsyncHTTPServer(eventLoopGroup: eventLoopGroup) { (request, responseWriter) in
            do {
                try await stack.handle(request, outputWriter: responseWriter, context: (),
                                       next: Self.handler)
            } catch {
                // In an actual implementation this would be more complex error handling,
                // potentially looking at the writer state to determine if an error response
                // could be sent
                let logger = Logger(label: "Request")
                logger.error("Unable to complete request due to \(String(describing: error))")
            }
        }
        
        let serviceGroup = ServiceGroup(
            services: [server],
            configuration: .init(gracefulShutdownSignals: [.sigterm]),
            logger: logger
        )
        try await serviceGroup.run()
    }
}
