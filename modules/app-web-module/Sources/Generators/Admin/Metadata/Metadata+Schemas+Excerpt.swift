import FeatherOpenAPI

extension Metadata.Schemas {
    struct Excerpt: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataExcerptField" }
        var example: String? =
            "Primary metadata description used for the homepage."
    }
}
