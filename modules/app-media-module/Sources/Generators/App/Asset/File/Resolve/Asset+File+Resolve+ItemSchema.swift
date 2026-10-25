import FeatherOpenAPI

extension Asset.File.Resolve {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Asset.File.Schemas.ID().reference(),
                "url": Asset.File.Schemas.URL(),
                "variants": VariantList(),
            ]
        }
    }
}
