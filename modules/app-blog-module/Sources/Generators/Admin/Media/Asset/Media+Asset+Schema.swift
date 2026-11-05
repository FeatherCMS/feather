public import FeatherOpenAPI

extension Media.Asset {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetSchema" }
        public var propertyMap: SchemaMap {
            [
                "assetId": Schemas.ID().reference(),
                "originalURL": Schemas.URL().reference(),
                "defaultURL": Schemas.URL().reference(),
                "variants": Variant.ListSchema().reference(),
            ]
        }

        public init() {}
    }
}
