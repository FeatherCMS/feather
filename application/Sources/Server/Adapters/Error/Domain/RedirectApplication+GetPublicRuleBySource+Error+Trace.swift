public import RedirectApplication

extension GetPublicRuleBySource.Error: ErrorTraceRepresentable {
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: String(describing: self),
            children: []
        )
    }
}
