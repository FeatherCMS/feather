import FeatherOpenAPI

extension Tag.Query {
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
