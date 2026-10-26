import FeatherBackend
import NIOHTTP1
import UserApplication
import UserModule

struct IdentityAddErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: Identity.Add.Error

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
            message: "A role assigned to the identity was not found.",
            reason: "role_not_found"
        )
    }
}
