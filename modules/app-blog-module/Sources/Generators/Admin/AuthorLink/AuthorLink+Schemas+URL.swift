import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct URL: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkURLField" }
        var example: String? = "/"
    }
}
