import FeatherOpenAPI

extension Tag.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog tag list response"
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
                "id": Tag.Schemas.ID().reference(),
                "title": Tag.Schemas.Title().reference(),
                "excerpt": Tag.Schemas.Excerpt().reference(),
                "imageAssetId": Tag.Schemas.ImageAssetID()
                    .reference(required: false),
                "createdAt": Tag.Schemas.CreatedAt().reference(),
                "updatedAt": Tag.Schemas.UpdatedAt().reference(),
            ]
        }
    }
}
