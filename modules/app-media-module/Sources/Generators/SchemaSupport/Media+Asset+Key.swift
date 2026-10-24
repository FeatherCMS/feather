public import FeatherOpenAPI

extension Media.Asset.Schemas {
    public struct Key: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetKeyField" }
        public var example: String? = "preview"
        public init() {}
    }
}
