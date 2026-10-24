import FeatherOpenAPI

extension RolePermission.List {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "roleId": RolePermission.Schemas.RoleID()
                    .reference(),
                "permissionId": RolePermission.Schemas
                    .PermissionID().reference(),
            ]
        }
    }
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionListSchema" }
        var items: (any SchemaRepresentable)? {
            RolePermission.List.Item()
                .reference()
        }
    }
}
