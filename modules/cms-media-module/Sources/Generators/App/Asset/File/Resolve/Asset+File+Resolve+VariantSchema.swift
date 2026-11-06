import FeatherOpenAPI

extension Asset.File.Resolve {
    struct VariantSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveVariantSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Asset.File.Schemas.Key().reference(),
                "url": Asset.File.Schemas.URL(),
            ]
        }
    }
}
