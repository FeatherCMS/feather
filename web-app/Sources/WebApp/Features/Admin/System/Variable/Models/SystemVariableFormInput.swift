import Foundation

struct SystemVariableFormInput: Codable, Sendable, Equatable, Hashable {

    let name: String
    let value: String
    let notes: String

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedValue: String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
