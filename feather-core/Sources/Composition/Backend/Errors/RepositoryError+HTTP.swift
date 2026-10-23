public import FeatherInfrastructure
public import NIOHTTP1

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

    public var status: HTTPResponseStatus {
        switch reason {
        case .database(.notFound):
            .notFound
        case .database(.duplicateKey):
            .conflict
        case .database(.rowDecoding), .unknown:
            .internalServerError
        }
    }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: message,
            reason: debugMessage
        )
    }
}
