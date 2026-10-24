import FeatherOpenAPI
import OpenAPIKit30

extension Article.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsArticleQueryItemSchema" }
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
