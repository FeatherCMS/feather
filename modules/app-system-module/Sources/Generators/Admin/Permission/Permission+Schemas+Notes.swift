import FeatherOpenAPI

extension Permission.Schemas {
    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionNotesField" }
        var example: String? = "Read system permissions."
    }
}
