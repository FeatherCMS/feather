//
//  NextBlock.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 02. 20..
//

import OpenAPIRuntime
import HTTPTypes

#if compiler(>=6.2)
typealias MiddlewareNextBlock =
    @concurrent @Sendable (
        HTTPRequest, HTTPBody?, ServerRequestMetadata
    ) async throws -> (HTTPResponse, HTTPBody?)
#else
typealias MiddlewareNextBlock =
    @Sendable (
        HTTPRequest, HTTPBody?, ServerRequestMetadata
    ) async throws -> (HTTPResponse, HTTPBody?)
#endif
