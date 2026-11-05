import FeatherOpenAPI

extension Asset.File.Variant.List {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetVariantListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "variantId": Asset.File.Variant.Schemas.ID(),
                "name": Asset.File.Variant.Schemas.Name(),
                "extension": Asset.File.Schemas.FileExtension(),
                "url": Asset.File.Schemas.URL(),
            ]
        }
    }

    struct Items: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetVariantItemsField" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }

    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetVariantListSchema" }
        var propertyMap: SchemaMap { ["items": Items().reference()] }
    }

}
