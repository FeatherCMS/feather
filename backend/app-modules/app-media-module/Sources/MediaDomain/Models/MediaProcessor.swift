import Domain
import struct Foundation.Date

public struct MediaProcessor: Model {
    public struct New: Sendable {
        public let id: String
        public let name: String
        public let matchExtensions: String
        public let commandTemplate: String
        public let isRequired: Bool
        public let isActive: Bool
    }

    public let id: String
    public var name: String
    public var matchExtensions: String
    public var commandTemplate: String
    public var isRequired: Bool
    public var isActive: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        matchExtensions: String,
        commandTemplate: String,
        isRequired: Bool,
        isActive: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.matchExtensions = matchExtensions
        self.commandTemplate = commandTemplate
        self.isRequired = isRequired
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension MediaProcessor {
    static func create(
        id: String,
        name: String,
        matchExtensions: String,
        commandTemplate: String,
        isRequired: Bool,
        isActive: Bool
    ) -> Self.New {
        .init(
            id: id,
            name: name,
            matchExtensions: matchExtensions,
            commandTemplate: commandTemplate,
            isRequired: isRequired,
            isActive: isActive
        )
    }
}
