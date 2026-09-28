//
//  Role.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain

public import struct Foundation.Date

public struct Role: Model {

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
    public let key: String
    public var name: String?
    public var notes: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        key: String,
        name: String?,
        notes: String?,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Role {

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
        notes: String?
    ) throws(Self.Error) {
        guard let notes else { return }
        guard notes.count < 255 else {
            throw .notesTooLong
        }
    }

    public static func create(
        key: String,
        name: String?,
        notes: String?
    ) throws(Self.Error) -> Self.New {
        try validate(key: key)
        try validate(name: name)
        try validate(notes: notes)

        return .init(
            key: key,
            name: name,
            notes: notes
        )
    }

    public mutating func update(
        name: String? = nil,
        notes: String? = nil
    ) throws(Self.Error) {
        let newName = name ?? self.name
        let newNotes = notes ?? self.notes

        try Self.validate(name: newName)
        try Self.validate(notes: newNotes)

        self.name = newName
        self.notes = newNotes
    }
}
