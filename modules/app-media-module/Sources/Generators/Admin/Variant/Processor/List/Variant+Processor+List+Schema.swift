import FeatherOpenAPI

extension Variant.Processor {
    enum List {}
}

extension Variant.Processor.List {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "MediaVariantProcessorListItemSchema"
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
