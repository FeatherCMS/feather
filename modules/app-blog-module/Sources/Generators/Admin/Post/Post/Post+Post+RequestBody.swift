import FeatherOpenAPI

extension Post.Post {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "title": BlogPostTitleField(),
                "excerpt": BlogPostExcerptField(),
                "content": BlogPostContentField(),
                "imageAssetId": BlogPostImageAssetIdField()
                    .reference(required: false),
                "authorIds": BlogPostAuthorIdsField()
                    .reference(required: false),
                "tagIds": BlogPostTagIdsField().reference(required: false),
            ]
        }
    }
}
