import FeatherOpenAPI

struct WebMetadataPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebMetadataCreateOperation() }
    var delete: (any OperationRepresentable)? { WebMetadataRemoveOperation() }
}

struct WebMetadataSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebMetadataSearchOperation() }
}

struct WebMetadataResolvePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebMetadataResolveOperation() }
}

struct WebMetadataListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { WebMetadataListOperation() }
}

struct WebMetadataIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { WebMetadataGetOperation() }
    var put: (any OperationRepresentable)? { WebMetadataUpdateOperation() }
    var patch: (any OperationRepresentable)? { WebMetadataPatchOperation() }
}
