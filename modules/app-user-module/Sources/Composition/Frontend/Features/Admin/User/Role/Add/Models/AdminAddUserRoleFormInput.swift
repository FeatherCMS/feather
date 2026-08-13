import FeatherAdmin
import Foundation

public struct AdminAddUserRoleFormInput: Codable, Sendable, Equatable, Hashable
{

    public let id: String
    public let name: String
    public let notes: String

    public init(
        id: String,
        name: String,
        notes: String
    ) {
        self.id = id
        self.name = name
        self.notes = notes
    }

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedID: String {
        id.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
