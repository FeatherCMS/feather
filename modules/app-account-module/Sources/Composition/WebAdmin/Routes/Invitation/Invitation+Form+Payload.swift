import AccountModule

extension Invitation {
    enum Form {}
}

extension Invitation.Form {
    struct Payload: Sendable {
        let email: String
        let roleIDs: [String]
    }
}
