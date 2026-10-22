import FeatherOpenAPI

extension RolePermission {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/role-permissions":
                    RolePermission.PathItem(),
                "api/v1/admin/auth/role-permissions/query":
                    RolePermission.Query.PathItem(),
                "api/v1/admin/auth/role-permissions/{userRoleId}/{systemPermissionId}":
                    RolePermission.ID.PathItem(),
            ]
        }
    }
}
