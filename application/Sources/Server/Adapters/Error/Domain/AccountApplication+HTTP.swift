public import AccountApplication
import NIOHTTP1
public import FeatherBackend

private protocol AccountInvitationHTTPError: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    var message: String { get }
}

extension AccountInvitationHTTPError {

    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: message,
            children: []
        )
    }

    public var status: HTTPResponseStatus { .notFound }
    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: message,
            reason: "invitation_not_found"
        )
    }
}

extension AccountApplication.ResendInvitation.Error: AccountInvitationHTTPError
{
}

extension AccountApplication.CompleteInvitationRegistration.Error:
    AccountInvitationHTTPError
{
}

extension AccountApplication.ValidateInvitation.Error:
    AccountInvitationHTTPError
{
}
