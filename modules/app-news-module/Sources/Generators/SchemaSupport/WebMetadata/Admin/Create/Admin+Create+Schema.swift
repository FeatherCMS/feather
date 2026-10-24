public import FeatherOpenAPI
import OpenAPIKit30

public extension WebMetadata.Admin.Create {
    struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataCreateSchema" }
        public var propertyMap: SchemaMap {
            [
                "slug": WebMetadata.Admin.Schemas.Slug(),
                "template": WebMetadata.Admin.Schemas.Template()
                    .reference(required: false),
                "referenceType": WebMetadata.Admin.Schemas.ReferenceType()
                    .reference(required: false),
                "referenceId": WebMetadata.Admin.Schemas.ReferenceID()
                    .reference(required: false),
                "publicationDate": WebMetadata.Admin.Schemas.NullableTimestamp(
                    required: false
                ),
                "expirationDate": WebMetadata.Admin.Schemas.NullableTimestamp(
                    required: false
                ),
                "status": WebMetadata.Admin.Schemas.Status(),
                "title": WebMetadata.Admin.Schemas.NullableText(required: false),
                "excerpt": WebMetadata.Admin.Schemas.NullableText(required: false),
                "imageUrl": WebMetadata.Admin.Schemas.NullableText(required: false),
                "canonicalUrl": WebMetadata.Admin.Schemas.NullableText(required: false),
                "noIndex": WebMetadata.Admin.Schemas.NoIndex()
                    .reference(required: false),
                "primaryKeyword": WebMetadata.Admin.Schemas.NullableText(
                    required: false
                ),
                "cssCodeInjection": WebMetadata.Admin.Schemas.NullableText(
                    required: false
                ),
                "javascriptCodeInjection": WebMetadata.Admin.Schemas.NullableText(
                    required: false
                ),
                "structuredDataCodeInjection": WebMetadata.Admin.Schemas.NullableText(
                    required: false
                ),
            ]
        }

        public init() {}
    }
}
