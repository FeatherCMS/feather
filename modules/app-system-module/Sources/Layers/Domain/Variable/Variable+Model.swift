public import SystemModule
//
//  Variable+Model.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain

extension Variable {
    public struct Model: FeatherDomain.Model {

        public enum Error: DomainError {
            case keyTooShort
            case keyTooLong
            case nameTooShort
            case nameTooLong
            case valueTooLong
            case notesTooLong
        }

        public struct New: Sendable {
            public let key: String
            public let value: String
            public let name: String?
            public let notes: String?
        }

        public let id: String
        public var key: String
        public var value: String
        public var name: String?
        public var notes: String?

        package init(
            id: String,
            key: String,
            value: String,
            name: String?,
            notes: String?
        ) {
            self.id = id
            self.key = key
            self.value = value
            self.name = name
            self.notes = notes
        }
    }
}

extension Variable.Model {

    private static func validate(
        key: String
    ) throws(Self.Error) {
        guard !key.isEmpty else {
            throw .keyTooShort
        }
        guard key.unicodeScalars.count < 255 else {
            throw .keyTooLong
        }
    }

    private static func validate(
        name: String?
    ) throws(Self.Error) {
        guard let name else { return }
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
        notes: String?
    ) throws(Self.Error) {
        guard let notes else { return }
        guard notes.count < 255 else {
            throw .notesTooLong
        }
    }

    public static func create(
        key: String,
        value: String,
        name: String?,
        notes: String?
    ) throws(Self.Error) -> Self.New {
        try validate(key: key)
        try validate(name: name)
        try validate(value: value)
        try validate(notes: notes)

        return .init(
            key: key,
            value: value,
            name: name,
            notes: notes
        )
    }

    public mutating func update(
        key: FieldChange<String> = .unchanged,
        name: OptionalFieldChange<String> = .unchanged,
        value: FieldChange<String> = .unchanged,
        notes: OptionalFieldChange<String> = .unchanged
    ) throws(Self.Error) {
        let newKey = key.apply(to: self.key)
        let newName = name.apply(to: self.name)
        let newValue = value.apply(to: self.value)
        let newNotes = notes.apply(to: self.notes)

        try Self.validate(key: newKey)
        try Self.validate(name: newName)
        try Self.validate(value: newValue)
        try Self.validate(notes: newNotes)

        self.key = newKey
        self.name = newName
        self.value = newValue
        self.notes = newNotes
    }
}
