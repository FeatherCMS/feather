import FeatherOpenAPI

extension Asset.Folder {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Post.Operation() }
        var get: (any OperationRepresentable)? { List.Operation() }
    }
}
