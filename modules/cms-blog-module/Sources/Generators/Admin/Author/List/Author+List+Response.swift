import FeatherOpenAPI

extension Author.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author list response"
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
                "id": Author.Schemas.ID().reference(),
                "name": Author.Schemas.Name().reference(),
                "excerpt": Author.Schemas.Excerpt().reference(),
                "profileImageAssetId": Author.Schemas.ProfileImageAssetID()
                    .reference(required: false),
                "createdAt": Author.Schemas.CreatedAt().reference(),
                "updatedAt": Author.Schemas.UpdatedAt().reference(),
            ]
        }
    }
}
