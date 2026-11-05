import FeatherOpenAPI

extension Metadata.Parameters {
    struct Slug: PathParameterRepresentable {
        var openAPIIdentifier: String { "MetadataSlugParameter" }
        var name: String { "slug" }
        var description: String? { "Web metadata slug" }
        var schema: any OpenAPISchemaRepresentable {
            MetadataSlugField().reference()
        }
    }
}
