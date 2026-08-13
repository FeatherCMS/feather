//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 05. 28..
//

import Foundation
import Hummingbird
import OpenAPIRuntime

public struct ClientAPIAuthMiddleware: ClientMiddleware {

    public var sessionToken: String?

    public init(sessionToken: String? = nil) {
        self.sessionToken = sessionToken
    }

    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next:
            @concurrent @Sendable (HTTPRequest, HTTPBody?, URL) async throws ->
            (
                HTTPResponse, HTTPBody?
            )
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var newRequest = request
        if let sessionToken {
            newRequest.headerFields[.authorization] = "Bearer \(sessionToken)"
        }
        return try await next(newRequest, body, baseURL)
    }
}
