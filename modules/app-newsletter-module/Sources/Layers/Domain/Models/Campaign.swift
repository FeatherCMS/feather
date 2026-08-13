import FeatherDomain

import struct Foundation.Date

public struct Campaign: Model {

    public enum Error: DomainError {
        case nameTooShort
        case nameTooLong
    }

    public struct New: Sendable {
        public let name: String
        public let fromEmail: String
    }

    public let id: String
    public var name: String
    public var fromEmail: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        fromEmail: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.fromEmail = fromEmail
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Campaign {

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
        name: String,
        fromEmail: String = ""
    ) throws(Self.Error) -> Self.New {
        try validate(name: name)
        return .init(name: name, fromEmail: fromEmail)
    }

    public mutating func update(
        name: String? = nil,
        fromEmail: String? = nil
    ) throws(Self.Error) {
        let newName = name ?? self.name
        try Self.validate(name: newName)
        self.name = newName
        if let fromEmail {
            self.fromEmail = fromEmail
        }
    }
}
