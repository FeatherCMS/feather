public import FeatherOpenAPI

extension MenuItem {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var post: (any OperationRepresentable)? { MenuItem.Post.Operation() }
        var delete: (any OperationRepresentable)? {
            MenuItem.Delete.Operation()
        }
    }
}
