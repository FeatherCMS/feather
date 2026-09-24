import FeatherContracts

struct SystemPermissionAddFormInput: Decodable, Sendable, Equatable, Hashable {
    let key: String
    let name: String?
    let notes: String?

    var normalizedKey: String { key.emptyToNil ?? "" }
    var normalizedName: String? { name?.emptyToNil }
    var normalizedNotes: String? { notes?.emptyToNil }
}
