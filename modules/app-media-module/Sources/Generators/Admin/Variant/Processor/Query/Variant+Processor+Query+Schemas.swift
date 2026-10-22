import FeatherOpenAPI

extension Variant.Processor.Query {
    enum Schemas {}
}

extension Variant.Processor.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "MediaVariantProcessorQueryItemSchema"
        }
        var propertyMap: SchemaMap {
            [
                "id": MediaVariantIdField().reference(),
                "name": MediaVariantNameField(),
                "matchExtensions": MediaVariantExtensionsField(),
                "commandTemplate": MediaVariantCommandField(),
                "isActive": MediaVariantBooleanField(),
            ]
        }
    }
}
