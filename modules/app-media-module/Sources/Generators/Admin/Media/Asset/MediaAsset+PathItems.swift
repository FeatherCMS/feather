import FeatherOpenAPI

struct MediaAssetPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { MediaAssetCreateOperation() }
    var delete: (any OperationRepresentable)? { MediaAssetNodeRemoveOperation() }
}

struct MediaAssetListPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { MediaAssetListOperation() }
}

struct MediaAssetResolvePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { MediaAssetResolveOperation() }
}

struct MediaAssetIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { MediaAssetGetOperation() }
    var patch: (any OperationRepresentable)? { MediaAssetUpdateOperation() }
}

struct MediaAssetVariantPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { MediaAssetVariantSearchOperation() }
}
