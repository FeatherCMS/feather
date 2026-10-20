import FeatherOpenAPI

extension Role {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Post.Operation() }
        var delete: (any OperationRepresentable)? { Delete.Operation() }
    }
}
