import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct Priority: IntSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkPriorityField" }
        var example: Int? = 10
    }
}
