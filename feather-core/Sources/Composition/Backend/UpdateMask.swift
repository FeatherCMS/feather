import Foundation

/// Parses a comma-separated list of fields into a type-safe update mask.
public struct UpdateMask<Field>: Sendable
where Field: Hashable & RawRepresentable & Sendable, Field.RawValue == String {

    public enum ParsingError: Error, Equatable, Sendable {
        case empty
        case invalidField(String)
    }

    private let fields: Set<Field>

    public init(_ value: String) throws(ParsingError) {
        guard !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            throw .empty
        }

        let names =
            value.split(separator: ",", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        guard !names.isEmpty else {
            throw .empty
        }

        var fields = Set<Field>()
        for name in names {
            guard !name.isEmpty, let field = Field(rawValue: name) else {
                throw .invalidField(name)
            }
            fields.insert(field)
        }

        guard !fields.isEmpty else {
            throw .empty
        }

        self.fields = fields
    }

    public func contains(_ field: Field) -> Bool {
        fields.contains(field)
    }
}
