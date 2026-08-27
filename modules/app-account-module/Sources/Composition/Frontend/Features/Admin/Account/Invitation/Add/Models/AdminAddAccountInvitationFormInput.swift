import FeatherAdmin
import Foundation

public struct AdminAddAccountInvitationFormInput: Codable, Sendable, Equatable,
    Hashable
{

    public let email: String
    public let roleIds: [String]?

    public init(email: String, roleIds: [String]? = nil) {
        self.email = email
        self.roleIds = roleIds
    }

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedRoleIDs: [String] {
        (roleIds ?? []).map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }.filter { !$0.isEmpty }
    }
}
