public import NIOHTTP1
public import FeatherBackend
public import SystemApplication
public import SystemModule

extension SystemModule.Permission.Edit.UseCase.Error:
    ErrorTraceRepresentable, HTTPErrorRepresentable
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
            message: "Permission not found.",
            reason: "permission_not_found"
        )
    }
}
