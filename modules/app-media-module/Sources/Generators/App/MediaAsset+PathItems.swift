import FeatherOpenAPI

struct MediaAssetResolvePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { MediaAssetResolveOperation() }
}
