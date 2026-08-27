import FeatherAdmin
import Foundation

struct AccountInvitationDetailsModel: Sendable {
    let id: String
    let email: String
    let roleIds: [String]
}
