import FeatherOpenAPI

extension Asset.File.Variant.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MediaAssetVariantListResponse" }
        var description: String = "MediaAsset variant list response"
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
