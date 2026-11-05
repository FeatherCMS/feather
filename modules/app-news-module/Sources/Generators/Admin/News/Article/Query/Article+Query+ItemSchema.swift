import FeatherOpenAPI

extension Article.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsArticleQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Article.Schemas.StringField(),
                "title": Article.Schemas.StringField(),
                "excerpt": Article.Schemas.StringField(),
                "imageAssetId": Article.Schemas.StringField()
                    .reference(required: false),
                "createdAt": Article.Schemas.TimestampField(),
                "updatedAt": Article.Schemas.TimestampField(),
            ]
        }
    }
}
