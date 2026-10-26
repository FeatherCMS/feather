import FeatherOpenAPI

extension Author.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author response"
        var schema = Schema().reference()
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": Author.Schemas.ID(),
                "name": Author.Schemas.Name(),
                "excerpt": Author.Schemas.Excerpt(),
                "content": Author.Schemas.Content(),
                "profileImageAssetId": Author.Schemas.ProfileImageAssetID()
                    .reference(required: false),
                "metadata": WebMetadataDetailSchema().reference(),
                "createdAt": Author.Schemas.CreatedAt(),
                "updatedAt": Author.Schemas.UpdatedAt(),
            ]
        }
    }
}
