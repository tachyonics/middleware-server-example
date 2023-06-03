//
//  ExampleMiddleware.swift
//

import SwiftMiddleware
import ExampleAsyncHTTP1Server

struct ExampleMiddleware<MiddlewareContext>: TransformingMiddlewareProtocol {
    
    func handle(_ input: HTTPServerRequest,
                outputWriter: HTTPServerResponseWriter,
                context: MiddlewareContext,
                next: (HTTPServerRequest,
                       ExampleResponseWriter<HTTPServerResponseWriter>,
                       MiddlewareContext) async throws -> Void) async throws {
        try await next(input, .init(wrapped: outputWriter), context)
    }
}
