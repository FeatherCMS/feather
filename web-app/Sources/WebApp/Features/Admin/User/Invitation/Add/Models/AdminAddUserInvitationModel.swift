import Foundation

struct AdminAddUserInvitationModel: Sendable {
    let email: String

    var payload: UserInvitationFormPayloadModel {
        .init(email: email)
    }
}
