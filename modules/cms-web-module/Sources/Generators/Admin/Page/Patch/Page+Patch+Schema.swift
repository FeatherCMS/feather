import FeatherOpenAPI

extension Page.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "PagePatchSchema" }
        var propertyMap: SchemaMap {
            [
                "title": Page.Schemas.Title().reference(required: false),
                "excerpt": Page.Schemas.Excerpt().reference(required: false),
                "content": Page.Schemas.Content().reference(required: false),
                "imageAssetId": Page.Schemas.ImageAssetID()
                    .reference(required: false),
            ]
        }
    }
}
