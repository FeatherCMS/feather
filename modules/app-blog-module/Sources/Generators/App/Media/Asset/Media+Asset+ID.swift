public import FeatherOpenAPI

extension Media.Asset.Schemas {
    public struct ID: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetIdField" }
        public var example: String? = "media_asset_1"
        public init() {}
    }
}
