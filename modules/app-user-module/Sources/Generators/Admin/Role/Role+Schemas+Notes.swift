import FeatherOpenAPI

extension Role.Schemas {
    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleNotesField" }
        var example: String? = "Management role."
    }
}
