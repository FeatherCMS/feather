import FeatherOpenAPI

extension Article.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsArticleDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Article.Schemas.StringField(),
                "title": Article.Schemas.StringField(),
                "excerpt": Article.Schemas.StringField(),
                "content": Article.Schemas.StringField(),
                "imageAssetId": Article.Schemas.StringField()
                    .reference(required: false),
                "categoryIds": Article.Schemas.CategoryIDsField(),
                "metadata": Metadata.Detail.Schema().reference(),
                "createdAt": Article.Schemas.TimestampField(),
                "updatedAt": Article.Schemas.TimestampField(),
            ]
        }
    }
}
