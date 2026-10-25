import FeatherOpenAPI

extension Tag.Post {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "title": Tag.Schemas.Title(),
                "excerpt": Tag.Schemas.Excerpt(),
                "content": Tag.Schemas.Content(),
                "imageAssetId": Tag.Schemas.ImageAssetID()
                    .reference(required: false),
            ]
        }
    }
}
