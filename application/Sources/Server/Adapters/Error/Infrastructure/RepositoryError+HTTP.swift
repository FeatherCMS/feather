import FeatherInfrastructure
import HTTPTypes
import NIOHTTP1
import OpenAPIRuntime

extension RepositoryError: ErrorTraceRepresentable {

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: debugMessage,
            children: underlyingTraces()
        )
    }
}

extension RepositoryError: HTTPErrorRepresentable {

    var status: HTTPResponseStatus {
        switch reason {
        case .database(.notFound):
            .notFound
        case .database(.rowDecoding), .database(.duplicateKey), .unknown:
            .internalServerError
        }
    }

    var content: ServerError.Details? {
        .init(
            code: status,
            message: message,
            reason: debugMessage
        )
    }
}
