public import FeatherBackend
public import FeatherInfrastructure
public import NIOHTTP1

extension QueryError: @retroactive HTTPErrorRepresentable {
    public var status: HTTPResponseStatus {
        switch reason {
        case .notFound:
            .notFound
        case .database, .unknown:
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
