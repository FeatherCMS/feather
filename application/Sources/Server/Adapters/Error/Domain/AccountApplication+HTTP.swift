import AccountApplication
import HTTPTypes
import NIOHTTP1
import OpenAPIRuntime

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

    var status: HTTPResponseStatus { .notFound }

    var content: ServerError.Details? {
        .init(
            code: .notFound,
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
