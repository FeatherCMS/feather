import FeatherOpenAPI
import OpenAPIKit30

struct NewsArticleListItemSchema: ObjectSchemaRepresentable {
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
