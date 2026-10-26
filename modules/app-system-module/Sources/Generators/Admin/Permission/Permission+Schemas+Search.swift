import FeatherOpenAPI

extension Permission.Schemas {
    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionSearch" }
        var example: String? = "admin"
    }
}
