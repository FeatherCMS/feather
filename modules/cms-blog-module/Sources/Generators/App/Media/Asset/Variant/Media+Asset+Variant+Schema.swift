public import FeatherOpenAPI

extension Media.Asset.Variant {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetVariantSchema" }
        public var propertyMap: SchemaMap {
            [
                "key": Media.Asset.Schemas.Key().reference(),
                "url": Media.Asset.Schemas.URL().reference(),
            ]
        }

        public init() {}
    }
}
