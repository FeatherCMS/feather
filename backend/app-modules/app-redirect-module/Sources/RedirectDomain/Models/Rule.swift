import Domain
import struct Foundation.Date

public struct Rule: Model {

    public enum Error: DomainError {
        case sourceTooShort
        case sourceTooLong
        case destinationTooShort
        case destinationTooLong
        case invalidStatusCode
        case notesTooLong
    }

    public struct New: Sendable {
        public let id: String
        public let source: String
        public let destination: String
        public let statusCode: Int
        public let notes: String
    }

    public let id: String
    public var source: String
    public var destination: String
    public var statusCode: Int
    public var notes: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        source: String,
        destination: String,
        statusCode: Int,
        notes: String,
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

public extension Rule {

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
        statusCode: Int
    ) throws(Self.Error) {
        guard [301, 302, 307, 308].contains(statusCode) else {
            throw .invalidStatusCode
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
        source: String,
        destination: String,
        statusCode: Int,
        notes: String
    ) throws(Self.Error) -> Self.New {
        try validate(source: source)
        try validate(destination: destination)
        try validate(statusCode: statusCode)
        try validate(notes: notes)

        return .init(
            id: id,
            source: source,
            destination: destination,
            statusCode: statusCode,
            notes: notes
        )
    }

    mutating func update(
        source: String? = nil,
        destination: String? = nil,
        statusCode: Int? = nil,
        notes: String? = nil
    ) throws(Self.Error) {
        let newSource = source ?? self.source
        let newDestination = destination ?? self.destination
        let newStatusCode = statusCode ?? self.statusCode
        let newNotes = notes ?? self.notes

        try Self.validate(source: newSource)
        try Self.validate(destination: newDestination)
        try Self.validate(statusCode: newStatusCode)
        try Self.validate(notes: newNotes)

        self.source = newSource
        self.destination = newDestination
        self.statusCode = newStatusCode
        self.notes = newNotes
    }
}
