import FeatherOpenAPI

extension Permission {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var post: (any OperationRepresentable)? {
            Permission.Post.Operation()
        }
        var delete: (any OperationRepresentable)? {
            Permission.Delete.Operation()
        }
    }
}
