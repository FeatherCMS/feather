import FeatherOpenAPI

extension Variant.Query {
    enum Schemas {}
}

extension Variant.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MediaVariantIdField().reference(),
                "key": MediaVariantKeyField(),
                "name": MediaVariantNameField(),
                "isRequired": MediaVariantBooleanField(),
                "isActive": MediaVariantBooleanField(),
            ]
        }
    }
}
