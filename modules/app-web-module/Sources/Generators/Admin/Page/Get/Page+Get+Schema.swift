import FeatherOpenAPI

extension Page.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "PageDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Page.Schemas.ID(),
                "title": Page.Schemas.Title(),
                "excerpt": Page.Schemas.Excerpt(),
                "content": Page.Schemas.Content(),
                "imageAssetId": Page.Schemas.ImageAssetID()
                    .reference(required: false),
                "metadata": MetadataDetailSchema().reference(),
                "createdAt": Page.Schemas.CreatedAt(),
                "updatedAt": Page.Schemas.UpdatedAt(),
            ]
        }
    }
}
