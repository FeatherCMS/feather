import FeatherOpenAPI
import OpenAPIKit30

extension RolePermission.Schemas {
    struct RoleID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionRoleIdField" }
        var example: String? = "role_manager"
    }
}
