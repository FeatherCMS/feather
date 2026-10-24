import FeatherOpenAPI

extension Article.Schemas {
    struct Create: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsArticleCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "title": NewsAdminOpenAPIComponents.StringField(),
                "excerpt": NewsAdminOpenAPIComponents.StringField(),
                "content": NewsAdminOpenAPIComponents.StringField(),
                "imageAssetId": NewsAdminOpenAPIComponents.StringField()
                    .reference(required: false),
                "categoryIds": NewsAdminOpenAPIComponents.CategoryIDsField()
                    .reference(required: false),
                "metadata": Metadata.Input.Schema().reference(),
            ]
        }
    }
}
