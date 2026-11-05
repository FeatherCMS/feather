import FeatherBackend
import NIOHTTP1
import RedirectApplication
import RedirectModule

struct RuleResolveErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: Rule.Resolve.Error

    var underlyingErrors: [any Error] { [] }

    func trace() -> ErrorTrace {
        .init(
            type: type(of: error),
            logMessage: String(describing: error),
            children: []
        )
    }

    var status: HTTPResponseStatus { .notFound }

    var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: "Redirect rule not found.",
            reason: "redirect_rule_not_found"
        )
    }
}
