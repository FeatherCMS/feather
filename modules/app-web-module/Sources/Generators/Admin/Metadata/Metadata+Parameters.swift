public import FeatherOpenAPI
import WebSharedOpenAPIGenerator

struct MetadataIdParameter: PathParameterRepresentable {
    var name: String { "metadataId" }
    var description: String? { "Metadata id" }
    var schema: any OpenAPISchemaRepresentable {
        MetadataIdField().reference()
    }
}
