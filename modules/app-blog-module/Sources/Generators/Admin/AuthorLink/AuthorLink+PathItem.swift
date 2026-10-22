import FeatherOpenAPI

extension AuthorLink {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var post: (any OperationRepresentable)? {
            AuthorLink.Post.Operation()
        }
        var delete: (any OperationRepresentable)? {
            AuthorLink.Delete.Operation()
        }
    }
}
