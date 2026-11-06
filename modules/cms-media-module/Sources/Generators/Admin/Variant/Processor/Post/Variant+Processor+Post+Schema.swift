import FeatherOpenAPI

extension Variant.Processor.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantProcessorCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "name": Variant.Schemas.Name(),
                "matchExtensions": Variant.Schemas.Extensions(),
                "commandTemplate": Variant.Schemas.Command(),
                "isActive": Variant.Schemas.Boolean(),
            ]
        }
    }
}
