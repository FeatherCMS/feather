import FeatherOpenAPI

extension Article.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsArticleDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": NewsAdminOpenAPIComponents.StringField(),
                "title": NewsAdminOpenAPIComponents.StringField(),
                "excerpt": NewsAdminOpenAPIComponents.StringField(),
                "content": NewsAdminOpenAPIComponents.StringField(),
                "imageAssetId": NewsAdminOpenAPIComponents.StringField()
                    .reference(required: false),
                "categoryIds": NewsAdminOpenAPIComponents.CategoryIDsField(),
                "metadata": Metadata.Detail.Schema().reference(),
                "createdAt": NewsAdminOpenAPIComponents.TimestampField(),
                "updatedAt": NewsAdminOpenAPIComponents.TimestampField(),
            ]
        }
    }
}
