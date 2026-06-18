import FeatherOpenAPI

struct WebMetadataIdParameter: PathParameterRepresentable {
    var name: String { "webMetadataId" }
    var description: String? { "WebMetadata id" }
    var schema: any OpenAPISchemaRepresentable {
        WebMetadataIdField().reference()
    }
}
