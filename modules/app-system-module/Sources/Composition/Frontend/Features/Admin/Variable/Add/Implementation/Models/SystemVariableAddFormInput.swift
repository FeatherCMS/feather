import Foundation
import FeatherContracts

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
        name?.emptyToNil
    }

    var normalizedKey: String {
        key.emptyToNil ?? ""
    }

    var normalizedValue: String {
        value.emptyToNil ?? ""
    }

    var normalizedNotes: String? {
        notes?.emptyToNil
    }
}
