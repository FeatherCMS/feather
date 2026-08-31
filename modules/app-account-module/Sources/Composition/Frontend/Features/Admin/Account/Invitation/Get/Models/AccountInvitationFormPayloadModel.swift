import FeatherAdmin
import Foundation

struct AccountInvitationFormPayloadModel: Sendable {
    let email: String
    let roleIDs: [String]
}
