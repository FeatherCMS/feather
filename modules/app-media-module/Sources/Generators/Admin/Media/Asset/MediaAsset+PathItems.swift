import FeatherOpenAPI

struct MediaAssetPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaAssetCreateOperation() }
    var delete: OperationRepresentable? { MediaAssetNodeRemoveOperation() }
}

struct MediaAssetSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaAssetSearchOperation() }
}

struct MediaAssetResolvePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaAssetResolveOperation() }
}

struct MediaAssetIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaAssetGetOperation() }
    var patch: OperationRepresentable? { MediaAssetUpdateOperation() }
}

struct MediaAssetVariantPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaAssetVariantSearchOperation() }
}
