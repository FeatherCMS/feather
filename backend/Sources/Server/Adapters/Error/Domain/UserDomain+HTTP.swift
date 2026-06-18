import HTTPTypes
import NIOHTTP1
import OpenAPIRuntime
import UserDomain

extension Account.Error: ErrorTraceRepresentable {

    public var underlyingErrors: [any Error] {
        []
    }

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: String(describing: self),
            children: []
        )
    }
}

extension Account.Error: HTTPErrorRepresentable {

    var status: HTTPResponseStatus { .badRequest }

    var content: ServerError.Details? {
        let message: String
        switch self {
        case .emailTooShort:
            message = "Email is too short."
        case .emailTooLong:
            message = "Email is too long."
        case .passwordTooShort:
            message = "Password is too short."
        case .passwordTooLong:
            message = "Password is too long."
        case .passwordHashTooShort:
            message = "Password hash is too short."
        case .passwordHashTooLong:
            message = "Password hash is too long."
        case .passwordHashRequired:
            message = "Password hash is required."
        case .passwordRequired:
            message = "Password is required."
        }

        return .init(
            code: .badRequest,
            message: message,
            reason: String(describing: self)
        )
    }
}
