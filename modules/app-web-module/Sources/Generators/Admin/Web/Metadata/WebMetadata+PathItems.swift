import FeatherOpenAPI

struct WebMetadataPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMetadataCreateOperation() }
    var delete: OperationRepresentable? { WebMetadataDeleteOperation() }
}

struct WebMetadataSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMetadataSearchOperation() }
}

struct WebMetadataListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMetadataListOperation() }
}

struct WebMetadataIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMetadataGetOperation() }
    var put: OperationRepresentable? { WebMetadataUpdateOperation() }
    var patch: OperationRepresentable? { WebMetadataPatchOperation() }
}
