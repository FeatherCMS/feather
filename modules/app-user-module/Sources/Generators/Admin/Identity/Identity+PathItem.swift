import FeatherOpenAPI

extension Identity {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Post.Operation() }
        var delete: (any OperationRepresentable)? { Delete.Operation() }
    }
}
