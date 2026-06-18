import HTTPTypes
import NIOHTTP1
import OpenAPIRuntime
import Foundation

struct RandomErrorMiddleware: ServerMiddleware {
    private struct FailureResponse {
        let status: HTTPResponseStatus
        let message: String
        let reason: String
        let retryAfterDelay: Bool
    }

    private let percentage = 80
    private let minimumDelaySeconds = 1
    private let maximumDelaySeconds = 3
    private let failures = [
        FailureResponse(
            status: .badGateway,
            message: "Upstream service failure.",
            reason:
                "The request was interrupted by an upstream dependency failure.",
            retryAfterDelay: false
        ),
        FailureResponse(
            status: .serviceUnavailable,
            message: "Service temporarily unavailable.",
            reason:
                "The service is temporarily overloaded and cannot process the request.",
            retryAfterDelay: true
        ),
        FailureResponse(
            status: .gatewayTimeout,
            message: "Gateway timeout.",
            reason:
                "The upstream service did not respond before the timeout expired.",
            retryAfterDelay: true
        ),
        FailureResponse(
            status: .tooManyRequests,
            message: "Rate limit exceeded.",
            reason: "The request was rejected by a simulated throttling limit.",
            retryAfterDelay: true
        ),
        FailureResponse(
            status: .internalServerError,
            message: "Internal server error.",
            reason:
                "The request failed because of a simulated internal processing error.",
            retryAfterDelay: false
        ),
    ]

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: MiddlewareNextBlock
    ) async throws -> (HTTPResponse, HTTPBody?) {
        guard shouldIntercept(request) else {
            return try await next(request, body, metadata)
        }

        let delaySeconds = Int.random(
            in: self.minimumDelaySeconds...self.maximumDelaySeconds
        )
        try await Task.sleep(for: .seconds(delaySeconds))

        return try response(
            for: request,
            operationID: operationID,
            delaySeconds: delaySeconds
        )
    }

    private func shouldIntercept(
        _ request: HTTPRequest
    ) -> Bool {
        guard request.method != .options else {
            return false
        }
        guard let requestPath = requestPath(request) else {
            return false
        }
        guard requestPath != "/health" else {
            return false
        }
        guard !isExcludedPath(requestPath) else {
            return false
        }
        return Int.random(in: 1...100) <= percentage
    }

    private func requestPath(
        _ request: HTTPRequest
    ) -> String? {
        guard let path = request.path else {
            return nil
        }
        return path.split(separator: "?", maxSplits: 1).first.map(String.init)
    }

    private func isExcludedPath(
        _ path: String
    ) -> Bool {
        let excludedPrefixes = [
            "/api/v1/auth/",
            "/api/v1/admin/user/auth/",
        ]
        if excludedPrefixes.contains(where: { path.hasPrefix($0) }) {
            return true
        }
        return path.contains("/sessions")
    }

    private func response(
        for request: HTTPRequest,
        operationID: String,
        delaySeconds: Int
    ) throws -> (HTTPResponse, HTTPBody?) {
        let failure =
            failures.randomElement()
            ?? FailureResponse(
                status: .serviceUnavailable,
                message: "Service temporarily unavailable.",
                reason:
                    "The service is temporarily overloaded and cannot process the request.",
                retryAfterDelay: true
            )
        let details = ServerError.Details(
            code: failure.status,
            message: failure.message,
            reason: failure.reason,
            requestPath: request.path,
            operationID: operationID
        )

        var response = HTTPResponse(status: details.status)
        if failure.retryAfterDelay {
            response.headerFields[.retryAfter] = "\(delaySeconds)"
        }

        if request.path?.hasPrefix("/api/") == true {
            response.headerFields[.contentType] =
                "application/json; charset=utf-8"
            let encoder = JSONEncoder()
            #if DEBUG
            encoder.outputFormatting = [
                .prettyPrinted,
                .withoutEscapingSlashes,
                .sortedKeys,
            ]
            #endif
            return (response, HTTPBody(try encoder.encode(details)))
        }

        response.headerFields[.contentType] = "text/plain; charset=utf-8"
        return (response, HTTPBody(details.plainTextValue))
    }
}
