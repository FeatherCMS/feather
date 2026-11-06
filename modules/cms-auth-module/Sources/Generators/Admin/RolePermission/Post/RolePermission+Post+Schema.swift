import FeatherOpenAPI

extension RolePermission.Post {
    struct DetailSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "roleId": RolePermission.Schemas.RoleID()
                    .reference(),
                "permissionId": RolePermission.Schemas
                    .PermissionID().reference(),
            ]
        }
    }
}
