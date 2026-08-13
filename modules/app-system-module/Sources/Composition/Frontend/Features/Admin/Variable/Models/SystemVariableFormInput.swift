import FeatherAdmin
import Foundation

public struct SystemVariableFormInput: Codable, Sendable, Equatable, Hashable {

    let id: String
    let value: String
    let name: String?
    let notes: String?

    public init(
        id: String,
        value: String,
        name: String?,
        notes: String?
    ) {
        self.id = id
        self.name = name
        self.value = value
        self.notes = notes
    }

    var normalizedID: String {
        id.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedName: String? {
        let value = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }

    var normalizedValue: String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String? {
        let value = notes?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }
}
