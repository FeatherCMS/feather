import FeatherAdmin

struct AccountInvitationFormPayloadModel: Sendable {
    let email: String
    let roleIDs: [String]
}
