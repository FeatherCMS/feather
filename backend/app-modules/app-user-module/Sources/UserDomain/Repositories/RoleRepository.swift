import Domain

public protocol RoleRepository: Repository {

    func findBy(
        id: String
    ) async throws -> Role?

    func insert(
        _ model: Role.New
    ) async throws -> Role

    func update(
        _ model: Role
    ) async throws -> Role

    func delete(
        id: String
    ) async throws -> Bool
}
