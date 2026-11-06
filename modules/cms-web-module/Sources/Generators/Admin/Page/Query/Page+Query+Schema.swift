import FeatherOpenAPI

extension Page.Query {
    enum Schemas {}
}

extension Page.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "PageQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Page.Schemas.ID().reference(),
                "title": Page.Schemas.Title().reference(),
                "excerpt": Page.Schemas.Excerpt().reference(),
                "imageAssetId": Page.Schemas.ImageAssetID()
                    .reference(required: false),
                "createdAt": Page.Schemas.CreatedAt().reference(),
                "updatedAt": Page.Schemas.UpdatedAt().reference(),
            ]
        }
    }
}
