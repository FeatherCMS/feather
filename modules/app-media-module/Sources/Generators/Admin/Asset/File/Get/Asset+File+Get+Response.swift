import FeatherOpenAPI

extension Asset.File.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MediaAssetDetailResponse" }
        var description: String = "MediaAsset response"
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
