public import FeatherOpenAPI

struct WebPageQueryItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebPageIdField().reference(),
            "title": WebPageTitleField().reference(),
            "excerpt": WebPageExcerptField().reference(),
            "imageAssetId": WebPageImageAssetIdField()
                .reference(required: false),
            "createdAt": WebPageCreatedAtField().reference(),
            "updatedAt": WebPageUpdatedAtField().reference(),
        ]
    }
}
