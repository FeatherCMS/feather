import FeatherOpenAPI

extension Page.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "PageListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }

    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "PageListItemSchema" }
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
