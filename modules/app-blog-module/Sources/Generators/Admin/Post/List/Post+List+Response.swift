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
