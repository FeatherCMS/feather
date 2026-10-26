import FeatherOpenAPI

extension Post.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog post response"
        var schema = Schema().reference()
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": Post.Schemas.ID(),
                "title": Post.Schemas.Title(),
                "excerpt": Post.Schemas.Excerpt(),
                "content": Post.Schemas.Content(),
                "imageAssetId": Post.Schemas.ImageAssetID()
                    .reference(required: false),
                "authorIds": Post.Schemas.AuthorIDs().reference(),
                "tagIds": Post.Schemas.TagIDs().reference(),
                "metadata": WebMetadataDetailSchema().reference(),
                "createdAt": Post.Schemas.CreatedAt(),
                "updatedAt": Post.Schemas.UpdatedAt(),
            ]
        }
    }
}
