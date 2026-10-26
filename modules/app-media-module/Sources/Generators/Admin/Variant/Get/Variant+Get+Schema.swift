import FeatherOpenAPI

extension Variant.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Variant.Schemas.ID().reference(),
                "key": Variant.Schemas.Key(),
                "name": Variant.Schemas.Name(),
                "isRequired": Variant.Schemas.Boolean(),
                "isActive": Variant.Schemas.Boolean(),
                "processors": Variant.Schemas.Processors(),
                "createdAt": Variant.Schemas.Timestamp(),
                "updatedAt": Variant.Schemas.Timestamp(),
            ]
        }
    }
}
