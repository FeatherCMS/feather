import AccountModule

extension Invitation.Add {

    struct Model: Sendable {
        let email: String
        let roleIDs: [String]

        var payload: Invitation.Form.Payload {
            .init(email: email, roleIDs: roleIDs)
        }
    }
}
