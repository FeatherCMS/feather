import FeatherOpenAPI

struct UserRolePermissionPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserRolePermissionCreateOperation() }
}

struct UserRolePermissionSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserRolePermissionSearchOperation() }
}

struct UserRolePermissionIdPathItems: PathItemRepresentable {
    var delete: OperationRepresentable? { UserRolePermissionDeleteOperation() }
}
