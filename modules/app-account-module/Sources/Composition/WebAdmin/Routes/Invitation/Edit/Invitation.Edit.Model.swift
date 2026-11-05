import AccountModule

extension Invitation.Edit {

    struct Model: Sendable {
        let id: String
        let email: String
        let roleIDs: [String]

        var payload: Invitation.Form.Payload {
            .init(email: email, roleIDs: roleIDs)
        }
    }
}
