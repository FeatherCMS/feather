import FeatherAdmin
import FeatherContracts

public struct AdminAddUserRoleFormInput: Decodable, Sendable, Equatable,
    Hashable
{

    public let name: String
    public let notes: String

    public init(
        name: String,
        notes: String
    ) {
        self.name = name
        self.notes = notes
    }

    var normalizedName: String {
        name.whitespaceTrimmed
    }

    var normalizedNotes: String {
        notes.whitespaceTrimmed
    }
}
