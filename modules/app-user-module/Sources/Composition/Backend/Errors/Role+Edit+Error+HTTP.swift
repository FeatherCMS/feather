public import FeatherBackend
public import NIOHTTP1
public import UserApplication
public import UserModule

extension Role.Edit.UseCase.Error: ErrorTraceRepresentable,
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
        DefaultHTTPErrorContent(
            message: "Role not found.",
            reason: "role_not_found"
        )
    }
}
