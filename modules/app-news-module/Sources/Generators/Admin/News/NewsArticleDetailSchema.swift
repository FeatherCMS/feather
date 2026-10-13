import FeatherOpenAPI
import OpenAPIKit30

struct NewsArticleDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": NewsAdminOpenAPIComponents.StringField(),
            "title": NewsAdminOpenAPIComponents.StringField(),
            "excerpt": NewsAdminOpenAPIComponents.StringField(),
            "content": NewsAdminOpenAPIComponents.StringField(),
            "imageAssetId": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "categoryIds": NewsAdminOpenAPIComponents.CategoryIDsField(),
            "metadata": NewsMetadataDetailSchema().reference(),
            "createdAt": NewsAdminOpenAPIComponents.TimestampField(),
            "updatedAt": NewsAdminOpenAPIComponents.TimestampField(),
        ]
    }
}
