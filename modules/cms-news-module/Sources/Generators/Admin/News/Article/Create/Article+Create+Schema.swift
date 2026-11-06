import FeatherOpenAPI

extension Article.Schemas {
    struct Create: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsArticleCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "title": StringField(),
                "excerpt": StringField(),
                "content": StringField(),
                "imageAssetId": StringField()
                    .reference(required: false),
                "categoryIds": CategoryIDsField()
                    .reference(required: false),
                "metadata": Metadata.Input.Schema().reference(),
            ]
        }
    }
}
