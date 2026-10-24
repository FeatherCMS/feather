import AccountModule

extension Invitation.Form {
    struct Payload: Sendable {
        let email: String
        let roleIDs: [String]
    }
}
