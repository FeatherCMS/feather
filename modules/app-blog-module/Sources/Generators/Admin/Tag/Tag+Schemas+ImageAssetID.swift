import FeatherOpenAPI

extension Tag.Schemas {
    struct ImageAssetID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogTagImageAssetIdField" }
        var example: String? = "media_asset_1"
    }
}
