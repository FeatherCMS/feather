public import AccountDomain
public import FeatherBackend
import NIOHTTP1

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

    public var status: HTTPResponseStatus { .badRequest }

    private var errorMessage: String {
        switch self {
        case .invalidUserId:
            return "User ID is invalid."
        case .invalidLanguage:
            return "Language is invalid."
        case .invalidTimezone:
            return "Timezone is invalid."
        case .invalidPageSize:
            return "Page size is invalid."
        }
    }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: errorMessage,
            reason: String(describing: self)
        )
    }
}
