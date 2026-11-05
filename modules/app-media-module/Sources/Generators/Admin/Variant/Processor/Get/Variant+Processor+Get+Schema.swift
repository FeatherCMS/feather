import FeatherOpenAPI

extension Variant.Processor.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantProcessorDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Variant.Schemas.ID().reference(),
                "variantId": Variant.Schemas.ID().reference(),
                "name": Variant.Schemas.Name(),
                "matchExtensions": Variant.Schemas.Extensions(),
                "commandTemplate": Variant.Schemas.Command(),
                "isActive": Variant.Schemas.Boolean(),
                "createdAt": Variant.Schemas.Timestamp(),
                "updatedAt": Variant.Schemas.Timestamp(),
            ]
        }
    }
}
