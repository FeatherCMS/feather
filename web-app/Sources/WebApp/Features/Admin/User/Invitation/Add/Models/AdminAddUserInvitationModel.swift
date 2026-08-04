import Foundation

struct AdminAddUserInvitationModel: Sendable {
    // TODO: Add role selection to the invitation form and submit roleIds when
    // the backend invitation contract is enabled in the frontend.
    let email: String

    var payload: UserInvitationFormPayloadModel {
        .init(email: email)
    }
}
