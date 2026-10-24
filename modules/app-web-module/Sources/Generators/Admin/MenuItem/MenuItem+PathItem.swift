public import FeatherOpenAPI

extension MenuItem {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { MenuItem.Post.Operation() }
        var delete: (any OperationRepresentable)? {
            MenuItem.Delete.Operation()
        }
    }
}
