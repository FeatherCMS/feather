//import FeatherError

public struct RepositoryError: Error {

    public enum Reason: Sendable, Equatable, Hashable, Codable {

        public enum Database: Sendable, Equatable, Hashable, Codable {
            case rowDecoding
            case duplicateKey
            case notFound
        }

        case database(Database)
        case unknown
    }

    public var reason: Reason
    public var debugMessage: String
    public var message: String
    public var underlyingErrors: [Error]

    public init(
        reason: Reason,
        logMessage: String,
        userFriendlyMessage: String,
        underlyingErrors: [Error] = []
    ) {
        self.reason = reason
        self.debugMessage = logMessage
        self.message = userFriendlyMessage
        self.underlyingErrors = underlyingErrors
    }
}
