//
//  Variable.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

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
        public let value: String
        public let name: String?
        public let notes: String?
    }

    public let id: String
    public var value: String
    public var name: String?
    public var notes: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        value: String,
        name: String?,
        notes: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.value = value
        self.name = name
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Variable {

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
        id: String,
        value: String,
        name: String?,
        notes: String?
    ) throws(Self.Error) -> Self.New {
        try validate(name: name)
        try validate(value: value)
        try validate(notes: notes)

        return .init(
            id: id,
            value: value,
            name: name,
            notes: notes
        )
    }

    public mutating func update(
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
