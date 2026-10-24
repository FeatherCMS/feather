import FeatherOpenAPI

extension Post.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog post list response"
        var schema = Schema().reference()
    }

    struct Schema: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? {
            ItemSchema().reference()
        }
    }

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
