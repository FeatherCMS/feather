//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 05. 28..
//

import Foundation
import Hummingbird
import OpenAPIRuntime

struct ClientAPIAuthMiddleware: ClientMiddleware {

    var sessionToken: String?

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next:
            @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (
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
