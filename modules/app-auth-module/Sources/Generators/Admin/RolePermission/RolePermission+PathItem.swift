import FeatherOpenAPI

struct AuthRolePermissionPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        AuthRolePermissionCreateOperation()
    }
    var delete: (any OperationRepresentable)? {
        AuthRolePermissionRemoveOperation()
    }
}
