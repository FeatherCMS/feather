import FeatherOpenAPI

struct MediaAssetResolvePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { MediaAssetResolveOperation() }
}
