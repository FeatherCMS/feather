import Domain

public protocol RolePermissionRepository: Repository {

    func findBy(
        roleId: String,
        permissionId: String
    ) async throws -> RolePermission?

    func insert(
        _ model: RolePermission.New
    ) async throws -> RolePermission

    func update(
        roleId: String,
        permissionId: String,
        _ model: RolePermission.New
    ) async throws -> RolePermission

    func delete(
        roleId: String,
        permissionId: String
    ) async throws -> Bool
}
