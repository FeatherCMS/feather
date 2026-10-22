public import FeatherOpenAPI

struct PageQueryItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": PageIdField().reference(),
            "title": PageTitleField().reference(),
            "excerpt": PageExcerptField().reference(),
            "imageAssetId": PageImageAssetIdField()
                .reference(required: false),
            "createdAt": PageCreatedAtField().reference(),
            "updatedAt": PageUpdatedAtField().reference(),
        ]
    }
}
