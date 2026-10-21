public import FeatherBackend
public import NIOHTTP1
public import UserApplication
public import UserModule

extension Identity.Edit.UseCase.Error: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: String(describing: self),
            children: []
        )
    }

    public var status: HTTPResponseStatus { .notFound }

    public var content: any HTTPErrorContent {
        let message: String
        let reason: String
        switch self {
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
