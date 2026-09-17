import HTTPTypes
import NIOHTTP1
import OpenAPIRuntime
import UserDomain

extension Role.Error: HTTPErrorRepresentable {

    var status: HTTPResponseStatus { .badRequest }

    var content: ServerError.Details? {
        let message: String
        switch self {
        case .nameTooShort:
            message = "Role name must be at least 4 characters."
        case .nameTooLong:
            message = "Role name must be shorter than 255 characters."
        case .notesTooLong:
            message = "Role notes must be shorter than 255 characters."
        }

        return .init(
            code: .badRequest,
            message: message,
            reason: String(describing: self)
        )
    }
}
