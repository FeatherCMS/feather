import FeatherOpenAPI

struct WebMetadataPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMetadataCreateOperation() }
    var delete: OperationRepresentable? { WebMetadataRemoveOperation() }
}

struct WebMetadataSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMetadataSearchOperation() }
}

struct WebMetadataResolvePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMetadataResolveOperation() }
}

struct WebMetadataListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMetadataListOperation() }
}

struct WebMetadataIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { WebMetadataGetOperation() }
    var put: OperationRepresentable? { WebMetadataUpdateOperation() }
    var patch: OperationRepresentable? { WebMetadataPatchOperation() }
}
