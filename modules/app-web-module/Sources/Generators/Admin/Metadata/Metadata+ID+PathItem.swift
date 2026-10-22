public import FeatherOpenAPI

extension Metadata.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { MetadataGetOperation() }
        var put: (any OperationRepresentable)? { MetadataUpdateOperation() }
        var patch: (any OperationRepresentable)? { MetadataPatchOperation() }
    }
}
