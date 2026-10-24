import FeatherOpenAPI

extension Tag.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": BlogTagIdField().reference(),
                "title": BlogTagTitleField().reference(),
                "excerpt": BlogTagExcerptField().reference(),
                "imageAssetId": BlogTagImageAssetIdField()
                    .reference(required: false),
                "createdAt": BlogTagCreatedAtField().reference(),
                "updatedAt": BlogTagUpdatedAtField().reference(),
            ]
        }
    }
}
