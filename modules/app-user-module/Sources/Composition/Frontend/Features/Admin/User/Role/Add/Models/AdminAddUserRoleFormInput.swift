import FeatherAdmin
import FeatherContracts

public struct AdminAddUserRoleFormInput: Decodable, Sendable, Equatable,
    Hashable
{

    public let key: String
    public let name: String
    public let notes: String

    public init(
        key: String,
        name: String,
        notes: String
    ) {
        self.key = key
        self.name = name
        self.notes = notes
    }

    var normalizedName: String {
        name.whitespaceTrimmed
    }

    var normalizedKey: String {
        key.whitespaceTrimmed
    }

    var normalizedNotes: String {
        notes.whitespaceTrimmed
    }
}
