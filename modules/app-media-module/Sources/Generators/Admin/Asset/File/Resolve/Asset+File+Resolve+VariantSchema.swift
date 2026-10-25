import FeatherOpenAPI

extension Asset.File.Resolve {
    struct VariantSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveVariantSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Asset.File.Schemas.Key().reference(),
                "name": Asset.File.Variant.Schemas.Name(),
                "url": Asset.File.Schemas.URL(),
                "extension": Asset.File.Schemas.FileExtension(),
            ]
        }
    }
}
