public import FeatherBackend
public import FeatherModuleKit
public import NIOHTTP1

extension AuthError: @retroactive HTTPErrorRepresentable {
    public var status: HTTPResponseStatus {
        switch kind {
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        }
    }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(message: message, reason: message)
    }
}
