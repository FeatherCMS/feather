public import FeatherBackend
public import FeatherModuleKit
import NIOHTTP1

extension AuthError: HTTPErrorRepresentable {
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
