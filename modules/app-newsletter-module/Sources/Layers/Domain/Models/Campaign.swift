import FeatherDomain

import struct Foundation.Date

public struct Campaign: Model {

    public enum Error: DomainError {
        case keyTooShort
        case keyTooLong
        case nameTooShort
        case nameTooLong
    }

    public struct New: Sendable {
        public let key: String
        public let name: String
        public let fromEmail: String
    }

    public let id: String
    public var key: String
    public var name: String
    public var fromEmail: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        key: String,
        name: String,
        fromEmail: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.key = key
        self.name = name
        self.fromEmail = fromEmail
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Campaign {

    private static func validate(
        key: String
    ) throws(Self.Error) {
        guard !key.isEmpty else {
            throw .keyTooShort
        }
        guard key.count < 255 else {
            throw .keyTooLong
        }
    }

    private static func validate(
        name: String
    ) throws(Self.Error) {
        guard !name.isEmpty else {
            throw .nameTooShort
        }
        guard name.count < 255 else {
            throw .nameTooLong
        }
    }

    public static func create(
        key: String,
        name: String,
        fromEmail: String = ""
    ) throws(Self.Error) -> Self.New {
        try validate(key: key)
        try validate(name: name)
        return .init(key: key, name: name, fromEmail: fromEmail)
    }

    public mutating func update(
        key: String? = nil,
        name: String? = nil,
        fromEmail: String? = nil
    ) throws(Self.Error) {
        let newKey = key ?? self.key
        let newName = name ?? self.name
        try Self.validate(key: newKey)
        try Self.validate(name: newName)
        self.key = newKey
        self.name = newName
        if let fromEmail {
            self.fromEmail = fromEmail
        }
    }
}
