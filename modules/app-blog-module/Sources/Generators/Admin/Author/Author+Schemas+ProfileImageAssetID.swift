import FeatherOpenAPI

extension Author.Schemas {
    struct ProfileImageAssetID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorProfileImageAssetIdField" }
        var example: String? = "media_asset_1"
    }
}
