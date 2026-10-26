import FeatherOpenAPI

extension RolePermission {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/role-permissions":
                    PathItem(),
                "api/v1/admin/auth/role-permissions/query":
                    Query.PathItem(),
                "api/v1/admin/auth/role-permissions/{userRoleId}/{systemPermissionId}":
                    ID.PathItem(),
            ]
        }
    }
}
