import FeatherOpenAPI

extension RolePermission.BulkUpdate {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            Post.Operation()
        }
    }
}
