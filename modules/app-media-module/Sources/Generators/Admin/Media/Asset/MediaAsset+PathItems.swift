import FeatherOpenAPI

struct MediaAssetPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaAssetCreateOperation() }
    var delete: OperationRepresentable? { MediaAssetDeleteOperation() }
}

struct MediaAssetSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaAssetSearchOperation() }
}

struct MediaAssetIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaAssetGetOperation() }
    var patch: OperationRepresentable? { MediaAssetUpdateOperation() }
}

struct MediaAssetVariantPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaAssetVariantSearchOperation() }
}
