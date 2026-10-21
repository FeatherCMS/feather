import FeatherOpenAPI

enum RolePermission {}

extension RolePermission {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/role-permissions":
                    AuthRolePermissionPathItems(),
                "api/v1/admin/auth/role-permissions/search":
                    AuthRolePermissionSearchPathItems(),
                "api/v1/admin/auth/role-permissions/{userRoleId}/{systemPermissionId}":
                    AuthRolePermissionIdPathItems(),
            ]
        }
    }
}
