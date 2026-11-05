import FeatherOpenAPI

extension Post {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var delete: (any OperationRepresentable)? { Delete.Operation() }
    }
}

extension Post.PathItem {
    var post: (any OperationRepresentable)? { Post.Post.Operation() }
}
