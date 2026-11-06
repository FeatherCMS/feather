import FeatherOpenAPI

extension Metadata.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "slug": Metadata.Schemas.Slug().reference(required: false),
                "template": Metadata.Schemas.Template()
                    .reference(required: false),
                "publicationDate": MetadataNullableTimestampField(
                    required: false
                ),
                "expirationDate": MetadataNullableTimestampField(
                    required: false
                ),
                "status": Metadata.Schemas.Status().reference(required: false),
                "title": MetadataNullableTextField(required: false),
                "excerpt": MetadataNullableTextField(required: false),
                "imageUrl": MetadataNullableTextField(required: false),
                "canonicalUrl": MetadataNullableTextField(required: false),
                "noIndex": Metadata.Schemas.NoIndex()
                    .reference(required: false),
                "primaryKeyword": MetadataNullableTextField(required: false),
                "cssCodeInjection": MetadataNullableTextField(required: false),
                "javascriptCodeInjection": MetadataNullableTextField(
                    required: false
                ),
                "structuredDataCodeInjection": MetadataNullableTextField(
                    required: false
                ),
                "templateData": MetadataNullableTextField(required: false),
            ]
        }
    }
}
