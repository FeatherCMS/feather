import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Metadata.Resolve {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataResolveItemSchema" }
        var propertyMap: SchemaMap {
            [
                "referenceId": Metadata.Schemas.ReferenceID(),
                "slug": Metadata.Schemas.Slug(),
                "publicationDate": Metadata.Schemas.Timestamp(),
                "expirationDate": MetadataNullableTimestampField(
                    required: false
                ),
                "status": Metadata.Schemas.Status(),
                "availability": MetadataAvailabilityField().reference(),
            ]
        }
    }
}
