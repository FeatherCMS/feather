import AuthApplication
import HTTPTypes
import NIOHTTP1
import OpenAPIRuntime

extension AuthApplication.UseCaseError: ErrorTraceRepresentable {

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: debugMessage,
            children: underlyingTraces()
        )
    }
}

extension AuthApplication.UseCaseError: HTTPErrorRepresentable {

    var status: HTTPResponseStatus {
        switch reason {
        case .auth:
            return .unauthorized
        case .validation:
            return .badRequest
        case .persistence, .unknown:
            return .internalServerError
        }
    }

    var content: ServerError.Details? {
        .init(
            code: status,
            message: message,
            reason: debugMessage
        )
    }
}
