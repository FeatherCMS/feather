import UserModule

extension Identity.Add.Repository.Role {
    protocol Interface: Sendable {

        func list() async throws -> [Identity.Add.RoleOption]
    }
}
