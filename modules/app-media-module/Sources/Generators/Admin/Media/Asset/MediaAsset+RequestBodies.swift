import FeatherOpenAPI

struct MediaAssetCreateRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaAssetCreateSchema().reference()
    }
}

struct MediaAssetPatchRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable { MediaAssetPatchSchema().reference() }
}
