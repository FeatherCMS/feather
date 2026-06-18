import Domain
import struct Foundation.Date

public struct Variable: Model {

    public enum Error: DomainError {
        case nameTooShort
        case nameTooLong

        case valueTooLong

        case notesTooLong
    }

    public struct New: Sendable {
        public let id: String
        public let name: String
        public let value: String
        public let notes: String
    }

    public let id: String
    public var name: String
    public var value: String
    public var notes: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        value: String,
        notes: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.value = value
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension Variable {

    private static func validate(
        name: String
    ) throws(Self.Error) {
        guard name.count > 3 else {
            throw .nameTooShort
        }
        guard name.count < 255 else {
            throw .nameTooLong
        }
    }

    private static func validate(
        value: String
    ) throws(Self.Error) {
        guard value.count < 255 else {
            throw .valueTooLong
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
        name: String,
        value: String,
        notes: String
    ) throws(Self.Error) -> Self.New {
        try validate(name: name)
        try validate(value: value)
        try validate(notes: notes)

        return .init(
            id: id,
            name: name,
            value: value,
            notes: notes
        )
    }

    mutating func update(
        name: String? = nil,
        value: String? = nil,
        notes: String? = nil
    ) throws(Self.Error) {
        let newName = name ?? self.name
        let newValue = value ?? self.value
        let newNotes = notes ?? self.notes

        try Self.validate(name: newName)
        try Self.validate(value: newValue)
        try Self.validate(notes: newNotes)

        self.name = newName
        self.value = newValue
        self.notes = newNotes
    }
}
