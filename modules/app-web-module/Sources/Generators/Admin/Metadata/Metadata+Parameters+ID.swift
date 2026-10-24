import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Metadata.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "MetadataIdParameter" }
        var name: String { "metadataId" }
        var description: String? { "Metadata id" }
        var schema: any OpenAPISchemaRepresentable {
            MetadataIdField().reference()
        }
    }
}
