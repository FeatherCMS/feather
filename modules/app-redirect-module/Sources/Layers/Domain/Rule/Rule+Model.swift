public import FeatherDomain
public import Foundation
public import RedirectModule

extension Rule {
    public struct Model: FeatherDomain.Model {
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

        private static func validate(source: String) throws(Error) {
            guard !source.isEmpty else { throw .sourceTooShort }
            guard source.count < 255 else { throw .sourceTooLong }
        }

        private static func validate(destination: String) throws(Error) {
            guard !destination.isEmpty else { throw .destinationTooShort }
            guard destination.count < 255 else { throw .destinationTooLong }
        }

        private static func validate(notes: String?) throws(Error) {
            guard (notes?.count ?? 0) < 255 else { throw .notesTooLong }
        }

        public static func create(
            source: String,
            destination: String,
            statusCode: StatusCode,
            notes: String?
        ) throws(Error) -> New {
            try validate(source: source)
            let normalizedSource =
                source.hasPrefix("/")
                ? source
                : "/\(source)"
            try validate(source: normalizedSource)
            try validate(destination: destination)
            try validate(notes: notes)
            return .init(
                source: normalizedSource,
                destination: destination,
                statusCode: statusCode,
                notes: notes
            )
        }

        public mutating func update(
            source: FieldChange<String> = .unchanged,
            destination: FieldChange<String> = .unchanged,
            statusCode: FieldChange<StatusCode> = .unchanged,
            notes: OptionalFieldChange<String> = .unchanged
        ) throws(Error) {
            let sourceValue = source.apply(to: self.source)
            try Self.validate(source: sourceValue)
            let newSource =
                sourceValue.hasPrefix("/")
                ? sourceValue
                : "/\(sourceValue)"
            let newDestination = destination.apply(to: self.destination)
            let newStatusCode = statusCode.apply(to: self.statusCode)
            let newNotes = notes.apply(to: self.notes)

            try Self.validate(source: newSource)
            try Self.validate(destination: newDestination)
            try Self.validate(notes: newNotes)

            self.source = newSource
            self.destination = newDestination
            self.statusCode = newStatusCode
            self.notes = newNotes
        }
    }
}
