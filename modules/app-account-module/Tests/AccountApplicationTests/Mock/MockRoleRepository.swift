import UserDomain

actor MockRoleRepository: RoleRepository {
    func findBy(id: String) async throws -> Role? { nil }

    func findBy(name: String) async throws -> Role? { nil }

    func insert(_ model: Role.New) async throws -> Role {
        fatalError("not needed")
    }

    func update(_ model: Role) async throws -> Role { model }

    func delete(id: String) async throws -> Bool { false }
}
