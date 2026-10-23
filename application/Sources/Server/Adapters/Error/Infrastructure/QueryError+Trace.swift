public import FeatherBackend
public import FeatherInfrastructure

extension QueryError: @retroactive ErrorTraceRepresentable {
    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: debugMessage,
            children: underlyingTraces()
        )
    }
}
