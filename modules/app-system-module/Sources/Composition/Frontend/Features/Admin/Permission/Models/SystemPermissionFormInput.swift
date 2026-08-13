import FeatherAdmin
import Foundation

public struct SystemPermissionFormInput: Codable, Sendable, Equatable, Hashable
{

    let name: String?
    let notes: String?

    public init(
        name: String?,
        notes: String?
    ) {
        self.name = name
        self.notes = notes
    }

    var normalizedName: String? {
        let value = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }

    var normalizedNotes: String? {
        let value = notes?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }
}
