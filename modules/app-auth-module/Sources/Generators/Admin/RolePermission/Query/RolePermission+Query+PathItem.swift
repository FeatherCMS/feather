import FeatherOpenAPI

extension RolePermission.Query {

    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? {
            RolePermission.Query.Operation()
        }
    }
}
