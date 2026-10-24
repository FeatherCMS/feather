import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "title": BlogPostTitleField().reference(required: false),
                "excerpt": BlogPostExcerptField().reference(required: false),
                "content": BlogPostContentField().reference(required: false),
                "imageAssetId": BlogPostImageAssetIdField()
                    .nullable().reference(required: false),
                "authorIds": BlogPostAuthorIdsField()
                    .reference(required: false),
                "tagIds": BlogPostTagIdsField().reference(required: false),
            ]
        }
    }
}
