import FeatherOpenAPI

extension Asset.File.Resolve {
    struct RequestSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveRequestSchema" }
        var propertyMap: SchemaMap {
            [
                "ids": IDs(),
                "variants": Variants().reference(required: false),
            ]
        }
    }
}
