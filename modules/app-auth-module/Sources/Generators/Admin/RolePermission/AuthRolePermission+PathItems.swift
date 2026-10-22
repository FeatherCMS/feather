import FeatherOpenAPI

struct AuthRolePermissionPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        AuthRolePermissionCreateOperation()
    }
    var delete: (any OperationRepresentable)? {
        AuthRolePermissionRemoveOperation()
    }
}

struct AuthRolePermissionQueryPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        AuthRolePermissionQueryOperation()
    }
}

struct AuthRolePermissionIdPathItems: PathItemRepresentable {
}
