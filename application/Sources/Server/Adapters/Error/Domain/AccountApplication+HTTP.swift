public import AccountApplication
public import AccountModule
public import FeatherBackend
public import NIOHTTP1

extension AccountModule.Invitation.Resend.UseCase.Error:
    @retroactive ErrorTraceRepresentable, @retroactive HTTPErrorRepresentable
{
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(type: Self.self, logMessage: message, children: [])
    }

    public var status: HTTPResponseStatus { .notFound }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: message,
            reason: "invitation_not_found"
        )
    }
}

extension AccountModule.Invitation.CompleteRegistration.UseCase.Error:
    @retroactive ErrorTraceRepresentable, @retroactive HTTPErrorRepresentable
{
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(type: Self.self, logMessage: message, children: [])
    }

    public var status: HTTPResponseStatus { .notFound }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: message,
            reason: "invitation_not_found"
        )
    }
}

extension AccountModule.Invitation.Validate.UseCase.Error:
    @retroactive ErrorTraceRepresentable, @retroactive HTTPErrorRepresentable
{
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(type: Self.self, logMessage: message, children: [])
    }

    public var status: HTTPResponseStatus { .notFound }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: message,
            reason: "invitation_not_found"
        )
    }
}
