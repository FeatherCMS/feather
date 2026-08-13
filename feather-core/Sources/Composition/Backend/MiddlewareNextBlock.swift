import HTTPTypes
import OpenAPIRuntime

#if compiler(>=6.2)
public typealias MiddlewareNextBlock =
    @concurrent @Sendable (
        HTTPRequest, HTTPBody?, ServerRequestMetadata
    ) async throws -> (HTTPResponse, HTTPBody?)
#else
public typealias MiddlewareNextBlock =
    @Sendable (
        HTTPRequest, HTTPBody?, ServerRequestMetadata
    ) async throws -> (HTTPResponse, HTTPBody?)
#endif
