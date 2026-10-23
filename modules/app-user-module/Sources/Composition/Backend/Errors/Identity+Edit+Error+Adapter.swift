import FeatherBackend
import NIOHTTP1
import UserApplication
import UserModule

struct IdentityEditErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: Identity.Edit.UseCase.Error

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
        let message: String
        let reason: String
        switch error {
        case .identityNotFound:
            message = "Identity not found."
            reason = "identity_not_found"
        case .roleNotFound:
            message = "A role assigned to the identity was not found."
            reason = "role_not_found"
        }
        return DefaultHTTPErrorContent(message: message, reason: reason)
    }
}
