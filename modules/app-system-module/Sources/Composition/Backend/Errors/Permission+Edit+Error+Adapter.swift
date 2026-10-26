import FeatherBackend
import NIOHTTP1
import SystemApplication
import SystemModule

struct PermissionEditErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: SystemModule.Permission.Edit.Error

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
            message: "Permission not found.",
            reason: "permission_not_found"
        )
    }
}
