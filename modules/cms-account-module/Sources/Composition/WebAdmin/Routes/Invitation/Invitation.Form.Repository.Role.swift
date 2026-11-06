import AccountModule

extension Invitation.Form.Repository {
    enum Role {}
}

extension Invitation.Form.Repository.Role {
    protocol Interface: Sendable {
        func list() async -> [Model]
    }
}
