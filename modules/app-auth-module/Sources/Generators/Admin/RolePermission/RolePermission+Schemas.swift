import FeatherOpenAPI
import OpenAPIKit30

extension RolePermission.Schemas {
    struct RoleID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionRoleIdField" }
        var example: String? = "role_manager"
    }
    struct PermissionID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionPermissionIdField" }
        var example: String? = "user_roles.list"
    }
}
