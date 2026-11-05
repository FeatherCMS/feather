import FeatherBackend
import NIOHTTP1
import RedirectDomain
import RedirectModule

struct RuleModelErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: Rule.Model.Error

    var underlyingErrors: [any Error] { [] }

    func trace() -> ErrorTrace {
        .init(
            type: type(of: error),
            logMessage: String(describing: error),
            children: []
        )
    }

    var status: HTTPResponseStatus { .badRequest }

    var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: String(describing: error),
            reason: String(describing: error)
        )
    }
}
