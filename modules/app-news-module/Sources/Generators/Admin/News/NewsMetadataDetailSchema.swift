import FeatherOpenAPI
import OpenAPIKit30

struct NewsMetadataDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": NewsAdminOpenAPIComponents.StringField(),
            "referenceType": NewsAdminOpenAPIComponents.StringField(),
            "referenceID": NewsAdminOpenAPIComponents.StringField(),
            "slug": NewsAdminOpenAPIComponents.StringField(),
            "template": NewsAdminOpenAPIComponents.StringField(),
            "publicationDate": NewsAdminOpenAPIComponents.TimestampField(),
            "expirationDate": NewsAdminOpenAPIComponents.TimestampField()
                .reference(required: false),
            "status": NewsAdminOpenAPIComponents.StatusField(),
            "title": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "excerpt": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "imageURL": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "canonicalURL": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "noIndex": NewsAdminOpenAPIComponents.BooleanField(),
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
            "createdAt": NewsAdminOpenAPIComponents.TimestampField(),
            "updatedAt": NewsAdminOpenAPIComponents.TimestampField(),
        ]
    }
}
