import FeatherAdmin
import FeatherContracts

public struct AdminEditAccountInvitationFormInput: Codable, Sendable, Equatable,
    Hashable
{

    public let email: String
    public let roleIds: [String]?

    public init(email: String, roleIds: [String]? = nil) {
        self.email = email
        self.roleIds = roleIds
    }

    var normalizedEmail: String {
        email.whitespaceTrimmed
    }

    var normalizedRoleIDs: [String] {
        (roleIds ?? [])
            .map {
                $0.whitespaceTrimmed
            }
            .filter { !$0.isEmpty }
    }
}
