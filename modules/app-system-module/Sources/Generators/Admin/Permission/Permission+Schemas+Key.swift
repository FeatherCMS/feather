import FeatherOpenAPI

extension Permission.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionKeyField" }
        var example: String? = "system.permission:read"
    }
}
