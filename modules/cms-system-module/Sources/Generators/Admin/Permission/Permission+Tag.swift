import FeatherOpenAPI

extension Permission {
    struct Tag: TagRepresentable {
        var name: String = "SystemPermissions"
        var description: String? = "Manage system permissions."
    }
}
