import FeatherOpenAPI

struct AuthRolePermissionPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthRolePermissionCreateOperation() }
    var delete: (any OperationRepresentable)? {
        AuthRolePermissionRemoveOperation()
    }
}

struct AuthRolePermissionSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthRolePermissionSearchOperation() }
}

struct AuthRolePermissionIdPathItems: PathItemRepresentable {
}
