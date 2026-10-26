import FeatherOpenAPI

extension Permission.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionNameField" }
        var example: String? = "system.permission:read"
    }
}
