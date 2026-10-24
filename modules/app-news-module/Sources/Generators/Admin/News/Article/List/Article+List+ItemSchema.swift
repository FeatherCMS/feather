import FeatherOpenAPI

extension Article.List {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsArticleListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": NewsAdminOpenAPIComponents.StringField(),
                "title": NewsAdminOpenAPIComponents.StringField(),
                "excerpt": NewsAdminOpenAPIComponents.StringField(),
                "imageAssetId": NewsAdminOpenAPIComponents.StringField()
                    .reference(required: false),
                "createdAt": NewsAdminOpenAPIComponents.TimestampField(),
                "updatedAt": NewsAdminOpenAPIComponents.TimestampField(),
            ]
        }
    }
}
