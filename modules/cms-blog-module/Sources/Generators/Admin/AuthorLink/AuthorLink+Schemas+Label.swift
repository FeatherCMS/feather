import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct Label: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkLabelField" }
        var example: String? = "Home"
    }
}
