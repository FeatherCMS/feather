import FeatherOpenAPI

extension Author.Query {
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
