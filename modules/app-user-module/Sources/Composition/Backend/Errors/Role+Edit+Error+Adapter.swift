import FeatherBackend
import NIOHTTP1
import UserApplication
import UserModule

struct RoleEditErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: Role.Edit.UseCase.Error

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
            message: "Role not found.",
            reason: "role_not_found"
        )
    }
}
