import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct IsBlank: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkIsBlankField" }
        var example: Bool? = false
    }
}
