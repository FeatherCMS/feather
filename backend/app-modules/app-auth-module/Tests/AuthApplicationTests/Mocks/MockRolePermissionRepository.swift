import AuthDomain

actor MockRolePermissionRepository: RolePermissionRepository {
    private(set) var insertCallCount = 0
    private(set) var deleteCallCount = 0

    private let result: RolePermission
    private let deleteResult: Bool

    init(
        result: RolePermission,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.deleteResult = deleteResult
    }

    func findBy(
        roleId: String,
        permissionId: String
    ) async throws -> RolePermission? {
        nil
    }

    func insert(
        _ model: RolePermission.New
    ) async throws -> RolePermission {
        insertCallCount += 1
        return result
    }

    func update(
        roleId: String,
        permissionId: String,
        _ model: RolePermission.New
    ) async throws -> RolePermission {
        result
    }

    func delete(
        roleId: String,
        permissionId: String
    ) async throws -> Bool {
        deleteCallCount += 1
        return deleteResult
    }
}
