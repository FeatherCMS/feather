import FeatherAdmin
import Foundation

public struct AdminEditUserRoleFormInput: Codable, Sendable, Equatable, Hashable
{

    public let name: String
    public let notes: String

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
