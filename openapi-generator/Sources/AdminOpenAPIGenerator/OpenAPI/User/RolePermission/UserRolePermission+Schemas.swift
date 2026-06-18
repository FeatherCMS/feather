import FeatherOpenAPI
import OpenAPIKit30

struct UserRolePermissionRoleIdField: StringSchemaRepresentable {
    var example: String? = "role_manager"
}

struct UserRolePermissionPermissionIdField: StringSchemaRepresentable {
    var example: String? = "user_roles.list"
}

struct UserRolePermissionCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "roleId": UserRolePermissionRoleIdField(),
            "permissionId": UserRolePermissionPermissionIdField(),
        ]
    }
}

struct UserRolePermissionDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "roleId": UserRolePermissionRoleIdField().reference(),
            "permissionId": UserRolePermissionPermissionIdField().reference(),
        ]
    }
}

struct UserRolePermissionListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "roleId": UserRolePermissionRoleIdField().reference(),
            "permissionId": UserRolePermissionPermissionIdField().reference(),
        ]
    }
}

struct UserRolePermissionListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserRolePermissionListItemSchema().reference()
    }
}
