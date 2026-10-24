import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

struct MetadataIdParameter: PathParameterRepresentable {
    var name: String { "id" }
    var description: String? { "Web metadata identifier" }
    var schema: any OpenAPISchemaRepresentable {
        MetadataReferenceIDField().reference()
    }

    init() {}
}

struct MetadataSlugParameter: PathParameterRepresentable {
    var name: String { "slug" }
    var description: String? { "Web metadata slug" }
    var schema: any OpenAPISchemaRepresentable {
        MetadataSlugField().reference()
    }

    init() {}
}
