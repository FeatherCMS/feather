import Foundation
import Hummingbird

public enum OpenAPIRepositoryError: Error {
    case unauthorized(message: String)
    case forbidden(message: String)
    case notFound(message: String)
    case failure(Failure)
    case transport(description: String)

    public struct Failure: Sendable {
        public let statusCode: Int
        public let responseBody: String?
        public let backendError: BackendError?

        public init(
            statusCode: Int,
            responseBody: String?,
            backendError: BackendError?
        ) {
            self.statusCode = statusCode
            self.responseBody = responseBody
            self.backendError = backendError
        }
    }

    public struct BackendError: Decodable, Sendable {
        public struct Trace: Decodable, Sendable {
            public let id: String
            public let message: String
            public let reasons: [Trace]?
        }

        public let code: Int
        public let message: String
        public let reason: String
        public let trace: Trace?
        public let requestPath: String?
        public let operationID: String?

        public init(
            code: Int,
            message: String,
            reason: String,
            trace: Trace?,
            requestPath: String?,
            operationID: String?
        ) {
            self.code = code
            self.message = message
            self.reason = reason
            self.trace = trace
            self.requestPath = requestPath
            self.operationID = operationID
        }
    }
}

extension OpenAPIRepositoryError {
    public static func parsedFailure(
        statusCode: Int,
        responseBody: String?
    ) -> Self {
        let trimmedBody = responseBody?
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        let backendError =
            trimmedBody
            .flatMap { body in body.data(using: .utf8) }
            .flatMap { data in
                try? JSONDecoder().decode(BackendError.self, from: data)
            }
        return .failure(
            .init(
                statusCode: statusCode,
                responseBody: trimmedBody,
                backendError: backendError
            )
        )
    }

    public var httpStatus: HTTPResponse.Status {
        switch self {
        case .unauthorized:
            return .unauthorized
        case .forbidden:
            return .forbidden
        case .notFound:
            return .notFound
        case .failure(let failure):
            return .init(code: failure.statusCode)
        case .transport:
            return .internalServerError
        }
    }

    public var displayTitle: String {
        switch self {
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not found"
        case .failure(let failure):
            return "Unexpected response from server (\(failure.statusCode))."
        case .transport:
            return "Transport error"
        }
    }

    public var errorTitle: String {
        displayTitle
    }

    public var technicalDetailsLines: [String] {
        switch self {
        case .unauthorized(let message):
            return [message]
        case .forbidden(let message):
            return [message]
        case .notFound(let message):
            return [message]
        case .failure(let failure):
            if let backendError = failure.backendError {
                var lines = [
                    "Status: \(failure.statusCode)",
                    "Message: \(backendError.message)",
                    "Reason: \(backendError.reason)",
                ]
                if let operationID = backendError.operationID,
                    !operationID.isEmpty
                {
                    lines.append("Operation ID: \(operationID)")
                }
                if let requestPath = backendError.requestPath,
                    !requestPath.isEmpty
                {
                    lines.append("Request path: \(requestPath)")
                }
                if let trace = backendError.trace {
                    lines.append("Trace:")
                    lines.append(trace.formattedValue())
                }
                return lines
            }
            if let responseBody = failure.responseBody, !responseBody.isEmpty {
                return [
                    "Status: \(failure.statusCode)",
                    "Response body: \(responseBody)",
                ]
            }
            return [
                "Status: \(failure.statusCode)",
                "Response body: <empty>",
            ]
        case .transport(let description):
            if description.isEmpty {
                return ["Transport request failed."]
            }
            return [
                "Transport request failed.",
                "Details: \(description)",
            ]
        }
    }

    public var displayMessage: String {
        technicalDetailsLines.joined(separator: "\n")
    }

    public var errorDescription: String {
        displayMessage
    }
}

extension OpenAPIRepositoryError.BackendError.Trace {
    fileprivate func formattedValue(
        prefix: String = "",
        isLast: Bool = true
    ) -> String {
        let branch = prefix.isEmpty ? "" : (isLast ? "└─ " : "├─ ")
        var output = "\(prefix)\(branch)\(id): \"\(message)\""
        let nextPrefix = prefix + (isLast ? "    " : "│   ")
        let childCount = reasons?.count ?? 0
        for (index, child) in (reasons ?? []).enumerated() {
            output +=
                "\n"
                + child.formattedValue(
                    prefix: nextPrefix,
                    isLast: index == childCount - 1
                )
        }
        return output
    }
}
