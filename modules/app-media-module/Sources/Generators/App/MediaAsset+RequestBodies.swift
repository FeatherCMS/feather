import FeatherOpenAPI

struct MediaAssetResolveRequestBody: JSONRequestBodyRepresentable {
    var schema: some SchemaRepresentable {
        MediaAssetResolveRequestSchema().reference()
    }
}
