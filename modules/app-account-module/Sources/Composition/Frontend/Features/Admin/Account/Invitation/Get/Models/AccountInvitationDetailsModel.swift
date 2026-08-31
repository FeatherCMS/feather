import FeatherAdmin
import Foundation

struct AccountInvitationDetailsModel: Sendable {
    let id: String
    let email: String
    let roleIds: [String]
    let roleNames: [String]

    init(
        id: String,
        email: String,
        roleIds: [String],
        roleNames: [String]? = nil
    ) {
        self.id = id
        self.email = email
        self.roleIds = roleIds
        self.roleNames = roleNames ?? roleIds
    }
}
