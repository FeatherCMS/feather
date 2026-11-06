import FeatherOpenAPI

extension Role.Schemas {
    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleSearch" }
        var example: String? = "editor"
    }
}
