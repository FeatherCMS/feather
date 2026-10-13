import FeatherOpenAPI

struct MediaVariantCreateRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaVariantCreateSchema().reference()
    }
}

struct MediaVariantProcessorCreateRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaVariantProcessorCreateSchema().reference()
    }
}
