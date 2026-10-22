import FeatherOpenAPI

struct AuthRolePermissionQueryPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        AuthRolePermissionQueryOperation()
    }
}
