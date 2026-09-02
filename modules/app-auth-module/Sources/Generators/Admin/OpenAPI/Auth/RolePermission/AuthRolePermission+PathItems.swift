import FeatherOpenAPI

struct AuthRolePermissionPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthRolePermissionCreateOperation() }
    var delete: OperationRepresentable? {
        AuthRolePermissionDeleteOperation()
    }
}

struct AuthRolePermissionSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthRolePermissionSearchOperation() }
}

struct AuthRolePermissionIdPathItems: PathItemRepresentable {
}
