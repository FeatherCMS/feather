import FeatherOpenAPI

extension RolePermission.Schemas {
    struct RoleID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionRoleIdField" }
        var example: String? = "role_manager"
    }
}
