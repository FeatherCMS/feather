public import FeatherBackend
public import NIOHTTP1
public import RedirectDomain
public import RedirectModule

extension RedirectModule.Rule.Model.Error: ErrorTraceRepresentable,
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

    public var status: HTTPResponseStatus { .badRequest }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: String(describing: self),
            reason: String(describing: self)
        )
    }
}
