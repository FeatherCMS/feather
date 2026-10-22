import FeatherOpenAPI

extension BlogAuthorLink {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var post: (any OperationRepresentable)? {
            BlogAuthorLink.Post.Operation()
        }
        var delete: (any OperationRepresentable)? {
            BlogAuthorLink.Delete.Operation()
        }
    }
}
