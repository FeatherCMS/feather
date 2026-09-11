import Foundation

public struct SystemVariableAddFormInput: Codable, Sendable, Equatable, Hashable {
    let id: String
    let value: String
    let name: String?
    let notes: String?

    var normalizedName: String? {
        let value = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }

    var normalizedID: String {
        id.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedValue: String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String? {
        let value = notes?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }
}
