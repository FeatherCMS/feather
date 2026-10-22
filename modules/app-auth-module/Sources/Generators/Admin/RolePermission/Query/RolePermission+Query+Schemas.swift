import FeatherOpenAPI
import OpenAPIKit30

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
