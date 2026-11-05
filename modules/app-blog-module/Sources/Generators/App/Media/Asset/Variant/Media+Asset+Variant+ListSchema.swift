public import FeatherOpenAPI

extension Media.Asset.Variant {
    public struct ListSchema: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetVariantListSchema" }
        public var items: (any SchemaRepresentable)? { Schema().reference() }
        public init() {}
    }
}
