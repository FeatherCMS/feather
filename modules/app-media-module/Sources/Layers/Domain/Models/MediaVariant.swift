public import FeatherDomain

public import struct Foundation.Date

public struct MediaVariant: Model {
    public struct New: Sendable {
        public let key: String
        public let name: String
        public let isRequired: Bool
        public let isActive: Bool
    }

    public let id: String
    public var key: String
    public var name: String
    public var isRequired: Bool
    public var isActive: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        key: String,
        name: String,
        isRequired: Bool,
        isActive: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.key = key
        self.name = name
        self.isRequired = isRequired
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public static func create(
        key: String,
        name: String,
        isRequired: Bool,
        isActive: Bool
    ) -> New {
        .init(
            key: key,
            name: name,
            isRequired: isRequired,
            isActive: isActive
        )
    }
}
