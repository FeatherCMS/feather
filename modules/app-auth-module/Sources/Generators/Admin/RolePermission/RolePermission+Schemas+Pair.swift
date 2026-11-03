import FeatherOpenAPI

extension RolePermission.Schemas {
    struct Pair: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "AuthRolePermissionPairSchema"
        }

        var propertyMap: SchemaMap {
            [
                "roleId": RolePermission.Schemas.RoleID().reference(),
                "permissionId": RolePermission.Schemas
                    .PermissionID().reference(),
            ]
        }
    }
}
