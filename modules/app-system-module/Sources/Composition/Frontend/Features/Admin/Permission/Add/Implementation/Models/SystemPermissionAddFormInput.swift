import FeatherContracts
import Foundation

struct SystemPermissionAddFormInput: Codable, Sendable, Equatable, Hashable {
    let key: String
    let name: String?
    let notes: String?
    let nonce: String?

    enum CodingKeys: String, CodingKey {
        case key, name, notes
        case nonce = "_nonce"
    }

    var normalizedKey: String { key.emptyToNil ?? "" }
    var normalizedName: String? { name?.emptyToNil }
    var normalizedNotes: String? { notes?.emptyToNil }
}
