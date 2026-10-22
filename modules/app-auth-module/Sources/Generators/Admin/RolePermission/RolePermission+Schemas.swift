import FeatherOpenAPI
import OpenAPIKit30

extension RolePermission.Schemas {

    struct AuthRolePermissionRoleIdField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionRoleIdField" }
        var example: String? = "role_manager"
    }
}

extension RolePermission.Schemas {

    struct AuthRolePermissionPermissionIdField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionPermissionIdField" }
        var example: String? = "user_roles.list"
    }
}

extension RolePermission.Schemas {

    struct AuthRolePermissionCreateSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "roleId": RolePermission.Schemas
                    .AuthRolePermissionRoleIdField(),
                "permissionId": RolePermission.Schemas
                    .AuthRolePermissionPermissionIdField(),
            ]
        }
    }
}

extension RolePermission.Schemas {

    struct AuthRolePermissionDetailSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "roleId": RolePermission.Schemas.AuthRolePermissionRoleIdField()
                    .reference(),
                "permissionId": RolePermission.Schemas
                    .AuthRolePermissionPermissionIdField().reference(),
            ]
        }
    }
}

extension RolePermission.Schemas {

    struct AuthRolePermissionListItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "roleId": RolePermission.Schemas.AuthRolePermissionRoleIdField()
                    .reference(),
                "permissionId": RolePermission.Schemas
                    .AuthRolePermissionPermissionIdField().reference(),
            ]
        }
    }
}

extension RolePermission.Query.Schemas {

    struct AuthRolePermissionQueryItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "roleId": RolePermission.Schemas.AuthRolePermissionRoleIdField()
                    .reference(),
                "permissionId": RolePermission.Schemas
                    .AuthRolePermissionPermissionIdField().reference(),
            ]
        }
    }
}

extension RolePermission.Schemas {

    struct AuthRolePermissionListSchema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionListSchema" }
        var items: (any SchemaRepresentable)? {
            RolePermission.Schemas.AuthRolePermissionListItemSchema()
                .reference()
        }
    }
}
