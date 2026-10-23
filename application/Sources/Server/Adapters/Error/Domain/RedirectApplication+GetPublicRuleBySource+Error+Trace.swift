public import FeatherBackend
public import RedirectApplication
public import RedirectModule

extension RedirectModule.Rule.Resolve.UseCase.Error: @retroactive ErrorTraceRepresentable {
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: String(describing: self),
            children: []
        )
    }
}
