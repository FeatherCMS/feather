import Foundation

public struct SystemVariableAddFormInput: Codable, Sendable, Equatable, Hashable
{
    let key: String
    let value: String
    let name: String?
    let notes: String?
    let nonce: String?

    enum CodingKeys: String, CodingKey {
        case key, value, name, notes
        case nonce = "_nonce"
    }

    var normalizedName: String? {
        let value = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }

    var normalizedKey: String {
        key.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedValue: String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String? {
        let value = notes?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? nil : value
    }
}
