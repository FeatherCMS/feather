import FeatherOpenAPI

extension Page.Schemas {
    struct ImageAssetID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "PageImageAssetIdField" }
        var example: String? = "media_asset_1"
    }
}
