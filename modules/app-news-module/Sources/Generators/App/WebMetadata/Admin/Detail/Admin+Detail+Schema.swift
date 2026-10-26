public import FeatherOpenAPI

extension WebMetadata.Admin.Detail {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataDetailSchema" }
        public var propertyMap: SchemaMap {
            [
                "id": WebMetadata.Admin.Schemas.ID(),
                "referenceType": WebMetadata.Admin.Schemas.ReferenceType()
                    .reference(required: false),
                "referenceId": WebMetadata.Admin.Schemas.ReferenceID()
                    .reference(required: false),
                "slug": WebMetadata.Admin.Schemas.Slug(),
                "template": WebMetadata.Admin.Schemas.Template(),
                "publicationDate": WebMetadata.Admin.Schemas.NullableTimestamp(
                    required: false
                ),
                "expirationDate": WebMetadata.Admin.Schemas.NullableTimestamp(
                    required: false
                ),
                "status": WebMetadata.Admin.Schemas.Status(),
                "title": WebMetadata.Admin.Schemas.NullableText(
                    required: false
                ),
                "excerpt": WebMetadata.Admin.Schemas.NullableText(
                    required: false
                ),
                "imageUrl": WebMetadata.Admin.Schemas.NullableText(
                    required: false
                ),
                "canonicalUrl": WebMetadata.Admin.Schemas.NullableText(
                    required: false
                ),
                "noIndex": WebMetadata.Admin.Schemas.NoIndex(),
                "primaryKeyword": WebMetadata.Admin.Schemas.PrimaryKeyword(),
                "cssCodeInjection": WebMetadata.Admin.Schemas.NullableText(
                    required: false
                ),
                "javascriptCodeInjection": WebMetadata.Admin.Schemas
                    .NullableText(
                        required: false
                    ),
                "structuredDataCodeInjection": WebMetadata.Admin.Schemas
                    .NullableText(
                        required: false
                    ),
                "createdAt": WebMetadata.Admin.Schemas.Timestamp(),
                "updatedAt": WebMetadata.Admin.Schemas.Timestamp(),
            ]
        }

        public init() {}
    }
}
