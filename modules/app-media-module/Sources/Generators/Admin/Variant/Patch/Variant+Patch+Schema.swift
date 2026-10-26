import FeatherOpenAPI

extension Variant.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Variant.Schemas.Key().reference(required: false),
                "name": Variant.Schemas.Name().reference(required: false),
                "isRequired": Variant.Schemas.Boolean().reference(required: false),
                "isActive": Variant.Schemas.Boolean().reference(required: false),
            ]
        }
    }
}
