import FeatherOpenAPI
import OpenAPIKit30

struct NewsMetadataInputSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "slug": NewsAdminOpenAPIComponents.StringField(),
            "status": NewsAdminOpenAPIComponents.StatusField(),
            "publicationDate": NewsAdminOpenAPIComponents.TimestampField()
                .reference(required: false),
            "expirationDate": NewsAdminOpenAPIComponents.TimestampField()
                .reference(required: false),
            "title": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "excerpt": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "imageURL": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "canonicalURL": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "noIndex": NewsAdminOpenAPIComponents.BooleanField()
                .reference(required: false),
            "primaryKeyword": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "cssCodeInjection": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "javascriptCodeInjection":
                NewsAdminOpenAPIComponents
                .StringField()
                .reference(required: false),
            "structuredDataCodeInjection":
                NewsAdminOpenAPIComponents
                .StringField()
                .reference(required: false),
        ]
    }
}
