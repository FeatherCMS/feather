import FeatherAdmin
import Foundation

struct AdminEditAccountInvitationModel: Sendable {
    let id: String
    let email: String

    var payload: AccountInvitationFormPayloadModel {
        .init(email: email)
    }
}
