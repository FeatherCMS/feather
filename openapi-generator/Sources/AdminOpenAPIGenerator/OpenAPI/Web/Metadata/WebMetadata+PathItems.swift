import FeatherOpenAPI

struct WebMetadataPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMetadataCreateOperation() }
    var delete: OperationRepresentable? { WebMetadataBulkDeleteOperation() }
}

struct WebMetadataSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMetadataSearchOperation() }
}

struct WebMetadataFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMetadataFiltersOperation() }
}

struct WebMetadataIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMetadataGetOperation() }
    var put: OperationRepresentable? { WebMetadataUpdateOperation() }
    var patch: OperationRepresentable? { WebMetadataPatchOperation() }
    var delete: OperationRepresentable? { WebMetadataDeleteOperation() }
}
