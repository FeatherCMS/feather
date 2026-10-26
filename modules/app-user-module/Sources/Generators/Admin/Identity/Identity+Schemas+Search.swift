import FeatherOpenAPI

extension Identity.Schemas {
    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentitySearch" }
        var example: String? = "Ada"
    }
}
