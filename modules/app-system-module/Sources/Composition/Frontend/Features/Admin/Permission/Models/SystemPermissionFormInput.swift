import FeatherAdmin
import Foundation

public struct SystemPermissionFormInput: Codable, Sendable, Equatable, Hashable
{

    let key: String
    let name: String?
    let notes: String?

    public init(
        key: String,
        name: String?,
        notes: String?
    ) {
        self.key = key
        self.name = name
        self.notes = notes
    }

    var normalizedName: String? {
        let value = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }

    var normalizedKey: String {
        key.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String? {
        let value = notes?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }
}
