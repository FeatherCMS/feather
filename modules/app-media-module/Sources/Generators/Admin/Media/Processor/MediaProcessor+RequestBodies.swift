import FeatherOpenAPI

struct MediaProcessorCreateRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaProcessorCreateSchema().reference()
    }
}
