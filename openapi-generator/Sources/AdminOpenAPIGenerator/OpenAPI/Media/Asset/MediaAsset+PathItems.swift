import FeatherOpenAPI

struct MediaAssetPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaAssetCreateOperation() }
}

struct MediaAssetSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaAssetSearchOperation() }
}

struct MediaAssetIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaAssetGetOperation() }
    var patch: OperationRepresentable? { MediaAssetUpdateOperation() }
    var delete: OperationRepresentable? { MediaAssetDeleteOperation() }
}

struct MediaAssetVariantPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { MediaAssetVariantSearchOperation() }
}
