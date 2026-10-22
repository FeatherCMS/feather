import FeatherOpenAPI

extension Post.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": BlogPostIdField().reference(),
                "title": BlogPostTitleField().reference(),
                "excerpt": BlogPostExcerptField().reference(),
                "imageAssetId": BlogPostImageAssetIdField()
                    .reference(required: false),
                "createdAt": BlogPostCreatedAtField().reference(),
                "updatedAt": BlogPostUpdatedAtField().reference(),
            ]
        }
    }
}
