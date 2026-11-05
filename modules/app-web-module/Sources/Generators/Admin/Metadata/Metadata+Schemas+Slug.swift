import FeatherOpenAPI

extension Metadata.Schemas {
    struct Slug: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataSlugField" }
        var example: String? = "homepage"
    }
}
