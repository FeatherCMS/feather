import FeatherAdmin
import Foundation

struct AdminAddAccountInvitationModel: Sendable {
    let email: String
    let roleIDs: [String]

    var payload: AccountInvitationFormPayloadModel {
        .init(email: email, roleIDs: roleIDs)
    }
}
