import FeatherOpenAPI

extension Author.Schemas {
    struct Excerpt: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorExcerptField" }
        var example: String? = "Short author summary."
    }
}
