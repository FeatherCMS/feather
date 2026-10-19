public import SystemModule
//
//  Permission+Model.swift
//  app-system-module
//

public import FeatherDomain

extension Permission {
    public struct Model: FeatherDomain.Model {

        public enum Error: DomainError {
            case keyTooShort
            case keyTooLong
            case nameTooShort
            case nameTooLong
            case notesTooLong
        }

        public struct New: Sendable {
            public let key: String
            public let name: String?
            public let notes: String?
        }

        public let id: String
        public var key: String
        public var name: String?
        public var notes: String?

        package init(
            id: String,
            key: String,
            name: String?,
            notes: String?
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}

extension Permission.Model {

    private static func validate(key: String) throws(Self.Error) {
        guard !key.isEmpty else { throw .keyTooShort }
        guard key.unicodeScalars.count < 255 else { throw .keyTooLong }
    }

    private static func validate(name: String?) throws(Self.Error) {
        guard let name else { return }
        guard name.count > 3 else { throw .nameTooShort }
        guard name.count < 255 else { throw .nameTooLong }
    }

    private static func validate(notes: String?) throws(Self.Error) {
        guard let notes else { return }
        guard notes.count < 255 else { throw .notesTooLong }
    }

    public static func create(
        key: String,
        name: String?,
        notes: String?
    ) throws(Self.Error) -> Self.New {
        try validate(key: key)
        try validate(name: name)
        try validate(notes: notes)
        return .init(key: key, name: name, notes: notes)
    }

    public mutating func update(
        key: FieldChange<String> = .unchanged,
        name: OptionalFieldChange<String> = .unchanged,
        notes: OptionalFieldChange<String> = .unchanged
    ) throws(Self.Error) {
        let newKey = key.apply(to: self.key)
        let newName = name.apply(to: self.name)
        let newNotes = notes.apply(to: self.notes)

        try Self.validate(key: newKey)
        try Self.validate(name: newName)
        try Self.validate(notes: newNotes)

        self.key = newKey
        self.name = newName
        self.notes = newNotes
    }
}
