import Foundation

struct WebMenuFormInput: Codable, Sendable, Equatable, Hashable {

    let key: String
    let name: String
    let notes: String

    var normalizedKey: String {
        key.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
