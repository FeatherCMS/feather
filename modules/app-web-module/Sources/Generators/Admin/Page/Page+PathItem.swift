public import FeatherOpenAPI

extension Page {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var post: (any OperationRepresentable)? { Page.Post.Operation() }
        var delete: (any OperationRepresentable)? { Page.Delete.Operation() }
    }
}
