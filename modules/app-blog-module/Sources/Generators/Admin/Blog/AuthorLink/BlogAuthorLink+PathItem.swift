import FeatherOpenAPI

extension BlogAuthorLink.Menu {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            BlogAuthorLink.Post.Operation()
        }
        var delete: (any OperationRepresentable)? {
            BlogAuthorLink.Delete.Operation()
        }
    }
}
