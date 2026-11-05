import FeatherOpenAPI

extension Variant.Processor.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantProcessorPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "name": Variant.Schemas.Name().reference(required: false),
                "matchExtensions": Variant.Schemas.Extensions()
                    .reference(required: false),
                "commandTemplate": Variant.Schemas.Command()
                    .reference(required: false),
                "isActive": Variant.Schemas.Boolean()
                    .reference(required: false),
            ]
        }
    }
}
