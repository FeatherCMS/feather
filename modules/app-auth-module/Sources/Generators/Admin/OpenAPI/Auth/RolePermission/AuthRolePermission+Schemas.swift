import FeatherOpenAPI
import OpenAPIKit30

struct AuthRolePermissionRoleIdField: StringSchemaRepresentable {
    var example: String? = "role_manager"
}

struct AuthRolePermissionPermissionIdField: StringSchemaRepresentable {
    var example: String? = "user_roles.list"
}

struct AuthRolePermissionCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "roleId": AuthRolePermissionRoleIdField(),
            "permissionId": AuthRolePermissionPermissionIdField(),
        ]
    }
}

struct AuthRolePermissionDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "roleId": AuthRolePermissionRoleIdField().reference(),
            "permissionId": AuthRolePermissionPermissionIdField().reference(),
        ]
    }
}

struct AuthRolePermissionListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "roleId": AuthRolePermissionRoleIdField().reference(),
            "permissionId": AuthRolePermissionPermissionIdField().reference(),
        ]
    }
}

struct AuthRolePermissionListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        AuthRolePermissionListItemSchema().reference()
    }
}
