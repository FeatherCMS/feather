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
                "title": BlogTagTitleField(),
                "excerpt": BlogTagExcerptField(),
                "content": BlogTagContentField(),
                "imageAssetId": BlogTagImageAssetIdField()
                    .reference(required: false),
            ]
        }
    }
}
