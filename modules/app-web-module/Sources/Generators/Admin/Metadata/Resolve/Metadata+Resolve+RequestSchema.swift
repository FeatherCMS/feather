import FeatherOpenAPI

extension Metadata.Resolve {
    struct RequestSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataResolveRequestSchema" }
        var propertyMap: SchemaMap {
            [
                "referenceType": Metadata.Schemas.ReferenceType(),
                "referenceIds": ReferenceIDs(),
            ]
        }
    }
}
