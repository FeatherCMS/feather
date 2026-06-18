import Domain
import struct Foundation.Date

public struct Menu: Model {

    public enum Error: DomainError {
        case keyTooShort
        case keyTooLong
        case nameTooShort
        case nameTooLong
        case notesTooLong
    }

    public struct New: Sendable {
        public let id: String
        public let key: String
        public let name: String
        public let notes: String
    }

    public let id: String
    public var key: String
    public var name: String
    public var notes: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        key: String,
        name: String,
        notes: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension Menu {

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

    private static func validate(
        notes: String
    ) throws(Self.Error) {
        guard notes.count < 255 else {
            throw .notesTooLong
        }
    }

    static func create(
        id: String,
        key: String,
        name: String,
        notes: String
    ) throws(Self.Error) -> Self.New {
        try validate(key: key)
        try validate(name: name)
        try validate(notes: notes)

        return .init(
            id: id,
            key: key,
            name: name,
            notes: notes
        )
    }

    mutating func update(
        key: String? = nil,
        name: String? = nil,
        notes: String? = nil
    ) throws(Self.Error) {
        let newKey = key ?? self.key
        let newName = name ?? self.name
        let newNotes = notes ?? self.notes

        try Self.validate(key: newKey)
        try Self.validate(name: newName)
        try Self.validate(notes: newNotes)

        self.key = newKey
        self.name = newName
        self.notes = newNotes
    }
}
