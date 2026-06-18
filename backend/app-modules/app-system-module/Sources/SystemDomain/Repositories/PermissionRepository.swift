import Domain

public protocol PermissionRepository: Repository {

    func insert(
        _ model: Permission.New
    ) async throws -> Permission

    func update(
        _ model: Permission
    ) async throws -> Permission

    func find(
        id: String
    ) async throws -> Permission?

    func delete(
        id: String
    ) async throws -> Bool
}
