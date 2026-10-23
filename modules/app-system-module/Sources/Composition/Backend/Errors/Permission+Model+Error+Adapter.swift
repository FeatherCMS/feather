import FeatherBackend
import NIOHTTP1
import SystemDomain
import SystemModule

struct PermissionModelErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: SystemModule.Permission.Model.Error

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
