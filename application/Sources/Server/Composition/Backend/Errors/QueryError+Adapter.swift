import FeatherBackend
import FeatherInfrastructure
import NIOHTTP1

struct QueryErrorAdapter: ErrorTraceRepresentable, HTTPErrorRepresentable {
    let error: QueryError

    var underlyingErrors: [any Error] { error.underlyingErrors }

    func trace() -> ErrorTrace {
        BackendErrorAdapter.trace(
            for: error,
            logMessage: error.debugMessage,
            underlyingErrors: underlyingErrors
        )
    }

    var status: HTTPResponseStatus {
        switch error.reason {
        case .notFound: .notFound
        case .database, .unknown: .internalServerError
        }
    }

    var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: error.message,
            reason: error.debugMessage
        )
    }
}
