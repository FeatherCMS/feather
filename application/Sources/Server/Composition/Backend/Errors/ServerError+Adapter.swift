import FeatherBackend
import OpenAPIRuntime

struct ServerErrorAdapter: Error, ErrorTraceRepresentable {
    let error: OpenAPIRuntime.ServerError

    var underlyingErrors: [any Error] { [error.underlyingError] }

    func trace() -> ErrorTrace {
        BackendErrorAdapter.trace(
            for: error,
            logMessage: error.operationID,
            underlyingErrors: underlyingErrors
        )
    }
}
