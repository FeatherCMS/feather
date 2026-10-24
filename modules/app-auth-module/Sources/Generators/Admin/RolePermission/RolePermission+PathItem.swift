import FeatherOpenAPI

extension RolePermission {

    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            RolePermission.Post.Operation()
        }
        var delete: (any OperationRepresentable)? {
            RolePermission.Delete.Operation()
        }
    }
}
