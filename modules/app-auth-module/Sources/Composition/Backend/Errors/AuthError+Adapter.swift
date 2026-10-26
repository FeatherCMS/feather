import FeatherBackend
import NIOHTTP1

struct AuthErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: any Error
    let status: HTTPResponseStatus
    let message: String
    let logMessage: String

    var underlyingErrors: [any Error] { [] }

    func trace() -> ErrorTrace {
        .init(
            type: type(of: error),
            logMessage: logMessage,
            children: []
        )
    }

    var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: message,
            reason: logMessage
        )
    }
}
