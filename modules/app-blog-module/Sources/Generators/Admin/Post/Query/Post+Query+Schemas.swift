import FeatherOpenAPI

extension Post.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": Post.Schemas.ID().reference(),
                "title": Post.Schemas.Title().reference(),
                "excerpt": Post.Schemas.Excerpt().reference(),
                "imageAssetId": Post.Schemas.ImageAssetID()
                    .reference(required: false),
                "createdAt": Post.Schemas.CreatedAt().reference(),
                "updatedAt": Post.Schemas.UpdatedAt().reference(),
            ]
        }
    }
}
