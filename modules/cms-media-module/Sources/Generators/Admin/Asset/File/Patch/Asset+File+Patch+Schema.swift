import FeatherOpenAPI

extension Asset.File.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "name": Asset.File.Schemas.Name().reference(required: false),
                "title": Asset.File.Schemas.NullableText(required: false),
                "altText": Asset.File.Schemas.NullableText(required: false),
            ]
        }
    }

}
