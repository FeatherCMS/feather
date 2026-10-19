public import AuthApplication
import NIOHTTP1
public import FeatherBackend

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

    public var status: HTTPResponseStatus {
        switch reason {
        case .auth:
            return .unauthorized
        case .validation:
            return .badRequest
        case .persistence, .unknown:
            return .internalServerError
        }
    }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: message,
            reason: debugMessage
        )
    }
}
