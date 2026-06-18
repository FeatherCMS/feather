import Foundation

struct AdminEditUserInvitationModel: Sendable {
    let id: String
    let email: String

    var payload: UserInvitationFormPayloadModel {
        .init(email: email)
    }
}
