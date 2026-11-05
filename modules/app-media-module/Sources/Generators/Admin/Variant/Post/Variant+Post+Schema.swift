import FeatherOpenAPI

extension Variant.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Variant.Schemas.Key(),
                "name": Variant.Schemas.Name(),
                "isRequired": Variant.Schemas.Boolean(),
                "isActive": Variant.Schemas.Boolean(),
            ]
        }
    }
}
