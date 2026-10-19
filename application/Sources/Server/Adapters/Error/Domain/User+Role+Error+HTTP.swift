public import FeatherBackend
import NIOHTTP1
public import UserDomain

extension Role.Error: HTTPErrorRepresentable {

    public var status: HTTPResponseStatus { .badRequest }

    private var errorMessage: String {
        switch self {
        case .keyTooShort:
            return "Role key is required."
        case .keyTooLong:
            return "Role key must be shorter than 255 characters."
        case .nameTooShort:
            return "Role name must be at least 4 characters."
        case .nameTooLong:
            return "Role name must be shorter than 255 characters."
        case .notesTooLong:
            return "Role notes must be shorter than 255 characters."
        }
    }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: errorMessage,
            reason: String(describing: self)
        )
    }
}
