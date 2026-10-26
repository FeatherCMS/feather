import FeatherOpenAPI

extension RolePermission {

    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Post.Operation()
        }
        var delete: (any OperationRepresentable)? {
            Delete.Operation()
        }
    }
}
