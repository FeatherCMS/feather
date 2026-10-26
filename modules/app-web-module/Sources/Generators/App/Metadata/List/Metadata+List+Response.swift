import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Metadata.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MetadataListResponse" }
        var description: String = "Public web metadata slugs"
        var schema: some SchemaRepresentable {
            MetadataSlugListSchema().reference()
        }
    }
}
