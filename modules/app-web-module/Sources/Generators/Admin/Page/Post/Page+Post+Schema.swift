import FeatherOpenAPI

extension Page.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "PageCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "title": Page.Schemas.Title(),
                "excerpt": Page.Schemas.Excerpt(),
                "content": Page.Schemas.Content(),
                "imageAssetId": Page.Schemas.ImageAssetID()
                    .reference(required: false),
            ]
        }
    }
}
