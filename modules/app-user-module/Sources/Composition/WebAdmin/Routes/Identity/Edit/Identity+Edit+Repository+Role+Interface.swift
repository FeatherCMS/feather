import UserModule

extension Identity.Edit.Repository.Role {
    protocol Interface: Sendable {

        func list() async throws -> [Identity.Edit.RoleOption]
    }
}
