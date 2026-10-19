import FeatherBackend
import HTTPTypes
import NIOHTTP1
import OpenAPIRuntime
//#if canImport(FoundationEssentials)
//import FoundationEssentials
//#else
//import Foundation
//#endif
import FeatherModuleKit
import Foundation

struct ErrorMiddleware: ServerMiddleware {

    private enum ErrorResponseContentType {
        case json
        case plainText
    }

    // MARK: -

    private func jsonResponse<T: Encodable>(
        status: HTTPResponse.Status,
        headers: HTTPHeaders?,
        body: T
    ) throws -> (HTTPResponse, HTTPBody?) {
        var response = HTTPResponse(status: status)
        if let headers {
            for header in headers {
                if let key = HTTPField.Name(header.name) {
                    response.headerFields[key] = header.value
                }
            }
        }
        response.headerFields[.contentType] = "application/json; charset=utf-8"
        let encoder = JSONEncoder()
        #if DEBUG
        encoder.outputFormatting = [
            .prettyPrinted,
            .withoutEscapingSlashes,
            .sortedKeys,
        ]
        #endif
        let data = try encoder.encode(body)
        return (response, HTTPBody(data))
    }

    private func plainTextResponse(
        status: HTTPResponse.Status,
        headers: HTTPHeaders?,
        body: String
    ) -> (HTTPResponse, HTTPBody?) {
        var response = HTTPResponse(status: status)
        if let headers {
            for header in headers {
                if let key = HTTPField.Name(header.name) {
                    response.headerFields[key] = header.value
                }
            }
        }
        response.headerFields[.contentType] = "text/plain; charset=utf-8"
        return (response, HTTPBody(body))
    }

    private func getErrorResponseContentType(
        from request: HTTPRequest
    ) -> ErrorResponseContentType {
        if request.path?.hasPrefix("/api/") == true {
            return .json
        }

        guard let acceptHeader = request.headerFields[.accept] else {
            return .plainText
        }

        let mediaTypes =
            acceptHeader
            .split(separator: ",")
            .map { component in
                component
                    .split(separator: ";", maxSplits: 1)
                    .first?
                    .whitespaceTrimmed
                    .lowercased() ?? ""
            }

        for mediaType in mediaTypes {
            switch mediaType {
            case "application/json", "application/*":
                return .json
            case "text/plain", "text/*", "*/*":
                return .plainText
            default:
                continue
            }
        }
        return .plainText
    }

    private func respond(
        with details: ServerError.Details,
        headers: HTTPHeaders?,
        using request: HTTPRequest
    ) throws -> (HTTPResponse, HTTPBody?) {
        switch getErrorResponseContentType(from: request) {
        case .json:
            return try jsonResponse(
                status: .init(code: Int(details.code.code)),
                headers: headers,
                body: HTTPErrorEnvelope(
                    error: details,
                    trace: debugTrace(details.trace)
                )
            )
        case .plainText:
            return plainTextResponse(
                status: .init(code: Int(details.code.code)),
                headers: headers,
                body: details.plainTextValue(
                    includeTrace: debugTrace(details.trace) != nil
                )
            )
        }
    }

    private func respond(
        with content: any HTTPErrorContent,
        status: HTTPResponseStatus,
        headers: HTTPHeaders?,
        trace: ErrorTrace?
    ) throws -> (HTTPResponse, HTTPBody?) {
        try jsonResponse(
            status: .init(code: Int(status.code)),
            headers: headers,
            body: HTTPErrorEnvelope(
                error: content,
                trace: debugTrace(trace)
            )
        )
    }

    private func debugTrace(_ trace: ErrorTrace?) -> ErrorTrace? {
        #if DEBUG
        trace
        #else
        nil
        #endif
    }

    private func enrich(
        _ details: ServerError.Details,
        request: HTTPRequest,
        operationID: String
    ) -> ServerError.Details {
        .init(
            code: details.code,
            message: details.message,
            reason: details.reason,
            trace: details.trace,
            requestPath: request.path,
            operationID: operationID
        )
    }

    // MARK: - intercept

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: MiddlewareNextBlock
    ) async throws -> (HTTPResponse, HTTPBody?) {
        do {
            return try await next(request, body, metadata)
        }
        catch let error as OpenAPIRuntime.ServerError {
            let underlyingError = error.underlyingError
            let httpError =
                (underlyingError as? any HTTPErrorRepresentable)
                ?? (underlyingError as? any ErrorTraceRepresentable)?
                    .lookup((any HTTPErrorRepresentable).self)
            if let httpError {
                let traceableError = underlyingError as? any ErrorTraceRepresentable
                let trace = traceableError?.trace()
                    ?? traceableError?
                        .lookup((any ErrorTraceRepresentable).self)?
                        .trace()
                return try respond(
                    with: httpError.content,
                    status: httpError.status,
                    headers: httpError.headers,
                    trace: trace
                )
            }
            let details = enrich(
                try error.parseDetails(),
                request: request,
                operationID: operationID
            )
            return try respond(
                with: details,
                headers: nil,
                using: request
            )
        }
        catch {
            return try respond(
                with: enrich(
                    .init(
                        code: .internalServerError,
                        message: "Unknown error.",
                        reason: "\(error)",
                        trace: (error as? any ErrorTraceRepresentable)?.trace()
                    ),
                    request: request,
                    operationID: operationID
                ),
                headers: nil,
                using: request
            )
        }
    }
}
