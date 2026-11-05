import FeatherBackend
import FeatherModuleKit
import NIOHTTP1

struct AuthorizationErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: AuthError

    var underlyingErrors: [any Error] { [] }

    func trace() -> ErrorTrace {
        .init(type: type(of: error), logMessage: error.message, children: [])
    }

    var status: HTTPResponseStatus {
        switch error.kind {
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        }
    }

    var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(message: error.message, reason: error.message)
    }
}
