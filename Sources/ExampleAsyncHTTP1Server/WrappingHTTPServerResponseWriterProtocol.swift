// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//
// WrappingHTTPServerResponseWriterProtocol.swift
// ExampleAsyncHTTP1Server
//

import NIOHTTP1
import NIOCore

public protocol WrappingHTTPServerResponseWriterProtocol: HTTPServerResponseWriterProtocol {
    associatedtype Wrapped: HTTPServerResponseWriterProtocol
    
    var wrapped: Wrapped { get }
}

public extension WrappingHTTPServerResponseWriterProtocol {
    
    func bodyPart(_ bytes: NIOCore.ByteBuffer) async throws {
        try await self.wrapped.bodyPart(bytes)
    }
    
    func updateStatus(updateProvider: @Sendable (inout HTTPResponseStatus) throws -> ()) async rethrows {
        try await self.wrapped.updateStatus(updateProvider: updateProvider)
    }
    
    func updateContentType(updateProvider: @Sendable (inout String?) throws -> ()) async rethrows {
        try await self.wrapped.updateContentType(updateProvider: updateProvider)
    }
    
    func updateBodyLength(updateProvider: @Sendable (inout ResponseBodyLength) throws -> ()) async rethrows {
        try await self.wrapped.updateBodyLength(updateProvider: updateProvider)
    }
    
    func updateHeaders(updateProvider: @Sendable (inout HTTPHeaders) throws -> ()) async rethrows {
        try await self.wrapped.updateHeaders(updateProvider: updateProvider)
    }
    
    func getStatus() async -> HTTPResponseStatus {
        return await self.wrapped.getStatus()
    }
    
    func getContentType() async -> String? {
        return await self.wrapped.getContentType()
    }
    
    func getBodyLength() async -> ResponseBodyLength {
        return await self.wrapped.getBodyLength()
    }
    
    func getHeaders() async -> HTTPHeaders {
        return await self.wrapped.getHeaders()
    }
    
    func getWriterState() async -> HTTPServerResponseWriterState {
        return await self.wrapped.getWriterState()
    }
    
    func commit() async throws {
        try await self.wrapped.commit()
    }
    
    func complete() async throws {
        try await self.wrapped.complete()
    }
    
    func asByteBuffer<Bytes>(_ bytes: Bytes) -> ByteBuffer where Bytes : Sendable, Bytes : Sequence, Bytes.Element == UInt8 {
        return self.wrapped.asByteBuffer(bytes)
    }
}
