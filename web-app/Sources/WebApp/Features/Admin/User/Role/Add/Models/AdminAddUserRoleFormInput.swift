import Foundation

struct AdminAddUserRoleFormInput: Codable, Sendable, Equatable, Hashable {

    let name: String
    let notes: String

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
