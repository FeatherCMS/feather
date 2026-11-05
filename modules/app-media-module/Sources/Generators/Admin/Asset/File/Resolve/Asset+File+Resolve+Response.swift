import FeatherOpenAPI

extension Asset.File.Resolve {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveResponse" }
        var description: String = "MediaAsset resolve response"
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
