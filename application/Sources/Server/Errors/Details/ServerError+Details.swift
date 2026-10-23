import FeatherBackend
import Hummingbird
import HTTPTypes
import Foundation

import NIOHTTP1
import OpenAPIRuntime

extension ServerError {

    struct Details: Encodable {
        enum CodingKeys: CodingKey {
            case message
            case reason
        }

        let code: HTTPResponseStatus
        let message: String
        let reason: String
        let trace: ErrorTrace?
        let requestPath: String?
        let operationID: String?

        init(
            code: HTTPResponseStatus,
            message: String,
            reason: String,
            trace: ErrorTrace? = nil,
            requestPath: String? = nil,
            operationID: String? = nil
        ) {
            self.code = code
            self.message = message
            self.reason = reason
            self.trace = trace
            self.requestPath = requestPath
            self.operationID = operationID
        }

        func encode(
            to encoder: any Encoder
        ) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(message, forKey: .message)
            try container.encode(reason, forKey: .reason)
        }

        var status: HTTPResponse.Status {
            .init(code: Int(code.code))
        }

        func plainTextValue(includeTrace: Bool) -> String {
            var bodyArray = [
                "CODE: " + String(code.code),
                "MESSAGE: " + message,
                "REASON: " + reason,
            ]
            if let requestPath {
                bodyArray.append("REQUEST PATH: " + requestPath)
            }
            if let operationID {
                bodyArray.append("OPERATION ID: " + operationID)
            }
            if includeTrace, let trace = trace?.plainTextValue {
                bodyArray.append("TRACE:\n" + trace)
            }
            return bodyArray.joined(separator: "\n")
        }
    }

    func parseDetails() throws -> Details {
        switch underlyingError {
        case let error as DecodingError:
            return .init(
                code: .badRequest,
                message: error.message,
                reason: error.reason,
                trace: trace()
            )
        default:
            let errorDescription = "\(underlyingError)"

            // NOTE: this is not ideal, but OpenAPIRuntime API is private
            if errorDescription.contains("Unexpected Content-Type header: ")
                || errorDescription.contains("Unexpected content type,")
            {
                let key = request.headerFields[.contentType] ?? "unknown"
                return .init(
                    code: .unsupportedMediaType,
                    message: "Unsupported media type.",
                    reason: "Unsupported Content-Type header: `\(key)`.",
                    trace: trace()
                )
            }
            if errorDescription.contains("Accept header") {
                let key = request.headerFields[.accept] ?? "unknown"
                return .init(
                    code: .unsupportedMediaType,
                    message: "Not acceptable.",
                    reason: "Unsupported Accept header value: `\(key)`.",
                    trace: trace()
                )
            }
            let reason: String
            if let error = underlyingError as? HTTPError {
                reason = error.body ?? error.status.description
            }
            else {
                reason = underlyingError.localizedDescription
            }
            return .init(
                code: .internalServerError,
                message: "Internal server error.",
                reason: reason,
                trace: trace()
            )
        }
    }
}
