import FeatherOpenAPI

extension Post.Schemas {
    struct Excerpt: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostExcerptField" }
        var example: String? = "Short post summary."
    }
}
