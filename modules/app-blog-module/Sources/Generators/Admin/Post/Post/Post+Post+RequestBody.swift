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
                "title": Post.Schemas.Title(),
                "excerpt": Post.Schemas.Excerpt(),
                "content": Post.Schemas.Content(),
                "imageAssetId": Post.Schemas.ImageAssetID()
                    .reference(required: false),
                "authorIds": Post.Schemas.AuthorIDs()
                    .reference(required: false),
                "tagIds": Post.Schemas.TagIDs().reference(required: false),
            ]
        }
    }
}
