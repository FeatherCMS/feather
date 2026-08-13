import FeatherOpenAPI

struct AuthRolePermissionPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthRolePermissionCreateOperation() }
}

struct AuthRolePermissionSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthRolePermissionSearchOperation() }
}

struct AuthRolePermissionIdPathItems: PathItemRepresentable {
    var delete: OperationRepresentable? { AuthRolePermissionDeleteOperation() }
}
