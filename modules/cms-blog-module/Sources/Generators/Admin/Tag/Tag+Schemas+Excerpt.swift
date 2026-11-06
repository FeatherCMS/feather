import FeatherOpenAPI

extension Tag.Schemas {
    struct Excerpt: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogTagExcerptField" }
        var example: String? = "Short tag summary."
    }
}
