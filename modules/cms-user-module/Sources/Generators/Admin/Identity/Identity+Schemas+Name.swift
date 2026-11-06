import FeatherOpenAPI

extension Identity.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityNameField" }
        var example: String? = "Root User"
    }
}
