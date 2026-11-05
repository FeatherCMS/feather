import FeatherBackend
import FeatherInfrastructure
import NIOHTTP1

struct RepositoryErrorAdapter: ErrorTraceRepresentable, HTTPErrorRepresentable {
    let error: RepositoryError

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
        case .database(.notFound): .notFound
        case .database(.duplicateKey): .conflict
        case .database(.rowDecoding), .unknown: .internalServerError
        }
    }

    var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: error.message,
            reason: error.debugMessage
        )
    }
}
