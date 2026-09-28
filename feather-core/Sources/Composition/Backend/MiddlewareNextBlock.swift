public import HTTPTypes
public import OpenAPIRuntime

public typealias MiddlewareNextBlock =
    @concurrent @Sendable (
        HTTPRequest, HTTPBody?, ServerRequestMetadata
    ) async throws -> (HTTPResponse, HTTPBody?)
