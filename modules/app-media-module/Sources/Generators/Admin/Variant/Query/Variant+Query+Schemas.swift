import FeatherOpenAPI

extension Variant.Query {
    enum Schemas {}
}

extension Variant.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Variant.Schemas.ID().reference(),
                "key": Variant.Schemas.Key(),
                "name": Variant.Schemas.Name(),
                "isRequired": Variant.Schemas.Boolean(),
                "isActive": Variant.Schemas.Boolean(),
            ]
        }
    }
}
