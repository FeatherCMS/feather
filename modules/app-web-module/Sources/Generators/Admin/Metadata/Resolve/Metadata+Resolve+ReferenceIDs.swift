import FeatherOpenAPI

extension Metadata.Resolve {
    struct ReferenceIDs: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MetadataReferenceIDsSchema" }
        var items: (any SchemaRepresentable)? { Metadata.Schemas.ReferenceID() }
    }
}
