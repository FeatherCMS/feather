import FeatherOpenAPI

extension RolePermission.Query {
    enum Schemas {}
}

extension RolePermission.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionQueryItemSchema" }
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
