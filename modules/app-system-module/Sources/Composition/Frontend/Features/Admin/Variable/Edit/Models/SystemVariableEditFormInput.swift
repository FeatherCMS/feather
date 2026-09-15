import FeatherContracts
import Foundation

public struct SystemVariableEditFormInput: Decodable, Sendable, Equatable,
    Hashable
{
    let key: String
    let value: String
    let name: String?
    let notes: String?

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
