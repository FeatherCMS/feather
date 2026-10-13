import FeatherOpenAPI

struct AuthRolePermissionTag: TagRepresentable {
    var name: String = "AuthRolePermissions"
    var description: String? = "Manage role-permission assignments."
}
