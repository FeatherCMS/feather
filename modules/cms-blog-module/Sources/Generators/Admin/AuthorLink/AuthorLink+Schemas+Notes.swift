import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkNotesField" }
        var example: String? = "Visible for all visitors."
    }
}
