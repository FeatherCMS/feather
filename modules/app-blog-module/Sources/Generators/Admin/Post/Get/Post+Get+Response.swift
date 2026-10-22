import BlogSharedOpenAPIGenerator
import FeatherOpenAPI

extension Post.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog post response"
        var schema = Schema().reference()
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": BlogPostIdField(),
                "title": BlogPostTitleField(),
                "excerpt": BlogPostExcerptField(),
                "content": BlogPostContentField(),
                "imageAssetId": BlogPostImageAssetIdField()
                    .reference(required: false),
                "authorIds": BlogPostAuthorIdsField().reference(),
                "tagIds": BlogPostTagIdsField().reference(),
                "metadata": WebMetadataDetailSchema().reference(),
                "createdAt": BlogPostCreatedAtField(),
                "updatedAt": BlogPostUpdatedAtField(),
            ]
        }
    }
}
