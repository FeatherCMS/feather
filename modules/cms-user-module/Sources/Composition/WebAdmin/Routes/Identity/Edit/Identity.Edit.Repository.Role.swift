import UserModule

extension Identity.Edit.Repository {
    enum Role {}
}

extension Identity.Edit.Repository.Role {
    protocol Interface: Sendable {

        func list() async throws -> [Identity.Edit.RoleOption]
    }
}
