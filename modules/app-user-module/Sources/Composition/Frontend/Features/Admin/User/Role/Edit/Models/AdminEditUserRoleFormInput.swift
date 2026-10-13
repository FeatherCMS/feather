import FeatherAdmin
import FeatherContracts

public struct AdminEditUserRoleFormInput: Decodable, Sendable, Equatable,
    Hashable
{

    public let name: String
    public let notes: String

    var normalizedName: String {
        name.whitespaceTrimmed
    }

    var normalizedNotes: String {
        notes.whitespaceTrimmed
    }
}
