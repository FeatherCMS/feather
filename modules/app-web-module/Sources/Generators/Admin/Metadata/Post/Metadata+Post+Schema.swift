import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Metadata.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "slug": Metadata.Schemas.Slug(),
                "template": Metadata.Schemas.Template().reference(required: false),
                "referenceType": Metadata.Schemas.ReferenceType().reference(required: false),
                "referenceId": Metadata.Schemas.ReferenceID().reference(required: false),
                "publicationDate": MetadataNullableTimestampField(required: false),
                "expirationDate": MetadataNullableTimestampField(required: false),
                "status": Metadata.Schemas.Status(),
                "title": MetadataNullableTextField(required: false),
                "excerpt": MetadataNullableTextField(required: false),
                "imageUrl": MetadataNullableTextField(required: false),
                "canonicalUrl": MetadataNullableTextField(required: false),
                "noIndex": Metadata.Schemas.NoIndex().reference(required: false),
                "primaryKeyword": MetadataNullableTextField(required: false),
                "cssCodeInjection": MetadataNullableTextField(required: false),
                "javascriptCodeInjection": MetadataNullableTextField(required: false),
                "structuredDataCodeInjection": MetadataNullableTextField(required: false),
            ]
        }
    }
}
