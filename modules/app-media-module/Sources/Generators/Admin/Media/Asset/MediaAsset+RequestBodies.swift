import FeatherOpenAPI

struct MediaAssetCreateRequestBody: BinaryRequestBodyRepresentable {}

struct MediaAssetPatchRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable { MediaAssetPatchSchema().reference() }
}

struct MediaAssetResolveRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaAssetResolveRequestSchema().reference()
    }
}
