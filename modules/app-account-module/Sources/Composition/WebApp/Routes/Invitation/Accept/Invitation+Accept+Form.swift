import AccountModule

extension Invitation.Accept {
    enum Form {}
}

extension Invitation.Accept.Form {
    struct Input: Codable, Sendable {
        let token: String
        let password: String
        let confirmation: String
    }
}
