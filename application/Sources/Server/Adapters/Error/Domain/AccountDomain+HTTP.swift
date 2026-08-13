import AccountDomain
import HTTPTypes
import NIOHTTP1
import OpenAPIRuntime

extension Settings.Error: ErrorTraceRepresentable {

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

extension Settings.Error: HTTPErrorRepresentable {

    var status: HTTPResponseStatus { .badRequest }

    var content: ServerError.Details? {
        let message: String
        switch self {
        case .invalidUserId:
            message = "User ID is invalid."
        case .invalidLanguage:
            message = "Language is invalid."
        case .invalidTimezone:
            message = "Timezone is invalid."
        case .invalidPageSize:
            message = "Page size is invalid."
        }

        return .init(
            code: .badRequest,
            message: message,
            reason: String(describing: self)
        )
    }
}
