//
//  ExampleResponseWriter.swift
//

import ExampleAsyncHTTP1Server
import NIOHTTP1
import NIOCore

/**
 For this writer, for each body part received, the writer will submit a lowercase version and then an uppercase version
 */
struct ExampleResponseWriter<Wrapped: HTTPServerResponseWriterProtocol>: WrappingHTTPServerResponseWriterProtocol {
    let wrapped: Wrapped
    
    init(wrapped: Wrapped) {
        self.wrapped = wrapped
    }
    
    func bodyPart(_ bytes: NIOCore.ByteBuffer) async throws {
        let bodyAsString = String(buffer: bytes)
        
        if let data = bodyAsString.lowercased().data(using: .utf8) {
            try await self.wrapped.bodyPart(data)
        }
        
        if let data = bodyAsString.uppercased().data(using: .utf8) {
            try await self.wrapped.bodyPart(data)
        }
    }
}
