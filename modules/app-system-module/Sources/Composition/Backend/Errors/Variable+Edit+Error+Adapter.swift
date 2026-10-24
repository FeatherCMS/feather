import FeatherBackend
import NIOHTTP1
import SystemApplication
import SystemModule

struct VariableEditErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: SystemModule.Variable.Edit.Error

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
            message: "Variable not found.",
            reason: "variable_not_found"
        )
    }
}
