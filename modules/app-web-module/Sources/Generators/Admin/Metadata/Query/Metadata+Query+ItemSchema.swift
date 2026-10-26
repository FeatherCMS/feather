import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Metadata.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MetadataIdField().reference(),
                "referenceType": Metadata.Schemas.ReferenceType()
                    .reference(required: false),
                "referenceId": Metadata.Schemas.ReferenceID()
                    .reference(required: false),
                "slug": Metadata.Schemas.Slug().reference(),
                "publicationDate": MetadataNullableTimestampField(
                    required: false
                ),
                "expirationDate": MetadataNullableTimestampField(
                    required: false
                ),
                "status": Metadata.Schemas.Status().reference(),
                "availability": MetadataAvailabilityField().reference(),
                "title": Metadata.Schemas.Title().reference(),
                "createdAt": Metadata.Schemas.Timestamp().reference(),
                "updatedAt": Metadata.Schemas.Timestamp().reference(),
            ]
        }
    }
}
