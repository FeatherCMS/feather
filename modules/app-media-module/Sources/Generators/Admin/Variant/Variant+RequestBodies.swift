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

struct MediaVariantPatchRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaVariantPatchSchema().reference()
    }
}

struct MediaVariantProcessorPatchRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaVariantProcessorPatchSchema().reference()
    }
}
