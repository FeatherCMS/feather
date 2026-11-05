import FeatherOpenAPI

extension Asset.File.Resolve {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Asset.File.Schemas.ID().reference(),
                "url": Asset.File.Schemas.URL(),
                "extension": Asset.File.Schemas.FileExtension(),
                "title": Asset.File.Schemas.NullableText(required: false),
                "altText": Asset.File.Schemas.NullableText(required: false),
                "variants": VariantList(),
            ]
        }
    }
}
