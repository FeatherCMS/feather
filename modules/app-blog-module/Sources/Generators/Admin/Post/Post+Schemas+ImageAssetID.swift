import FeatherOpenAPI

extension Post.Schemas {
    struct ImageAssetID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostImageAssetIdField" }
        var example: String? = "media_asset_1"
    }
}
