import FeatherOpenAPI

struct MediaProcessorIdParameter: PathParameterRepresentable {
    var name: String { "mediaProcessorId" }
    var description: String? { "MediaProcessor id" }
    var schema: any OpenAPISchemaRepresentable {
        MediaProcessorIdField().reference()
    }
}
