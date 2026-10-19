public import FeatherBackend
import FeatherInfrastructure

extension QueryError: ErrorTraceRepresentable {
    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: debugMessage,
            children: underlyingTraces()
        )
    }
}
