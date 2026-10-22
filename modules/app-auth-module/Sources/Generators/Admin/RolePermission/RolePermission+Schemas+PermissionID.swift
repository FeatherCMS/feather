import FeatherOpenAPI
import OpenAPIKit30

extension RolePermission.Schemas {
    struct PermissionID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionPermissionIdField" }
        var example: String? = "user_roles.list"
    }
}
