import FeatherOpenAPI

extension Tag.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog tag response"
        var schema = Schema().reference()
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": Tag.Schemas.ID(),
                "title": Tag.Schemas.Title(),
                "excerpt": Tag.Schemas.Excerpt(),
                "content": Tag.Schemas.Content(),
                "imageAssetId": Tag.Schemas.ImageAssetID()
                    .reference(required: false),
                "metadata": WebMetadataDetailSchema().reference(),
                "createdAt": Tag.Schemas.CreatedAt(),
                "updatedAt": Tag.Schemas.UpdatedAt(),
            ]
        }
    }
}
