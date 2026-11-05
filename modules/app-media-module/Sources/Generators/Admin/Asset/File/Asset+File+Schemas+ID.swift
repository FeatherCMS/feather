import FeatherOpenAPI

extension Asset.File.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetIdField" }
        var example: String? { "media_asset_1" }
    }
}
