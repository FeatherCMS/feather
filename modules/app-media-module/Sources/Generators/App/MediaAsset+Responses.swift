import FeatherOpenAPI

struct MediaAssetResolveResponse: JSONResponseRepresentable {
    var description: String = "MediaAsset resolve response"

    var schema: some SchemaRepresentable {
        MediaAssetResolveSchema().reference()
    }
}
