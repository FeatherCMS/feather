//
//  Rule.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

import struct Foundation.Date

public struct Rule: Model {

    public enum StatusCode: Int, Codable, CaseIterable, Sendable {
        case movedPermanently = 301
        case found = 302
        case temporaryRedirect = 307
        case permanentRedirect = 308
    }

    public enum Error: DomainError {
        case sourceTooShort
        case sourceTooLong
        case destinationTooShort
        case destinationTooLong
        case invalidStatusCode
        case notesTooLong
    }

    public struct New: Sendable {
        public let source: String
        public let destination: String
        public let statusCode: StatusCode
        public let notes: String?
    }

    public let id: String
    public var source: String
    public var destination: String
    public var statusCode: StatusCode
    public var notes: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        source: String,
        destination: String,
        statusCode: StatusCode,
        notes: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.source = source
        self.destination = destination
        self.statusCode = statusCode
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Rule {

    private static func validate(
        source: String
    ) throws(Self.Error) {
        guard !source.isEmpty else {
            throw .sourceTooShort
        }
        guard source.count < 255 else {
            throw .sourceTooLong
        }
    }

    private static func validate(
        destination: String
    ) throws(Self.Error) {
        guard !destination.isEmpty else {
            throw .destinationTooShort
        }
        guard destination.count < 255 else {
            throw .destinationTooLong
        }
    }

    private static func validate(
        notes: String?
    ) throws(Self.Error) {
        guard (notes?.count ?? 0) < 255 else {
            throw .notesTooLong
        }
    }

    public static func create(
        source: String,
        destination: String,
        statusCode: StatusCode,
        notes: String?
    ) throws(Self.Error) -> Self.New {
        try validate(source: source)
        try validate(destination: destination)
        try validate(notes: notes)

        return .init(
            source: source,
            destination: destination,
            statusCode: statusCode,
            notes: notes
        )
    }

    public mutating func update(
        source: String? = nil,
        destination: String? = nil,
        statusCode: StatusCode? = nil,
        notes: String? = nil
    ) throws(Self.Error) {
        let newSource = source ?? self.source
        let newDestination = destination ?? self.destination
        let newStatusCode = statusCode ?? self.statusCode
        let newNotes = notes ?? self.notes

        try Self.validate(source: newSource)
        try Self.validate(destination: newDestination)
        try Self.validate(notes: newNotes)

        self.source = newSource
        self.destination = newDestination
        self.statusCode = newStatusCode
        self.notes = newNotes
    }
}
