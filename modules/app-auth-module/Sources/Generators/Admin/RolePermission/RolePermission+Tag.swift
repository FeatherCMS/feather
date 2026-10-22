import FeatherOpenAPI

extension RolePermission {

    struct Tag: TagRepresentable {
        var name: String = "AuthRolePermissions"
        var description: String? = "Manage role-permission assignments."
    }
}
