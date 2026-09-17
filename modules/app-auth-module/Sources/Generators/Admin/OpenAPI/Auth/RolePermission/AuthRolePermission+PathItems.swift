import FeatherOpenAPI

struct AuthRolePermissionPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthRolePermissionCreateOperation() }
    var delete: OperationRepresentable? {
        AuthRolePermissionRemoveOperation()
    }
}

struct AuthRolePermissionSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthRolePermissionSearchOperation() }
}

struct AuthRolePermissionIdPathItems: PathItemRepresentable {
}
