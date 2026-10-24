import FeatherOpenAPI
import OpenAPIKit30

extension RolePermission.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "roleId": RolePermission.Schemas
                    .RoleID(),
                "permissionId": RolePermission.Schemas
                    .PermissionID(),
            ]
        }
    }
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
