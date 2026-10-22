public import FeatherOpenAPI

extension Metadata.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { WebMetadataGetOperation() }
        var put: (any OperationRepresentable)? { WebMetadataUpdateOperation() }
        var patch: (any OperationRepresentable)? { WebMetadataPatchOperation() }
    }
}
