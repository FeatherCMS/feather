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
                "id": Variant.Schemas.ID().reference(),
                "name": Variant.Schemas.Name(),
                "matchExtensions": Variant.Schemas.Extensions(),
                "commandTemplate": Variant.Schemas.Command(),
                "isActive": Variant.Schemas.Boolean(),
            ]
        }
    }
}
