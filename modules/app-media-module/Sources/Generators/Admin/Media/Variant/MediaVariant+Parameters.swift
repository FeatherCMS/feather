import FeatherOpenAPI

struct MediaVariantIdParameter: PathParameterRepresentable {
    var name: String { "mediaVariantId" }
    var description: String? { "Media variant id" }
    var schema: any OpenAPISchemaRepresentable { MediaVariantIdField().reference() }
}

struct MediaVariantProcessorIdParameter: PathParameterRepresentable {
    var name: String { "mediaVariantProcessorId" }
    var description: String? { "Media variant processor id" }
    var schema: any OpenAPISchemaRepresentable { MediaVariantIdField().reference() }
}
