import FeatherOpenAPI

struct UserRolePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { UserRoleCreateOperation() }
    var delete: (any OperationRepresentable)? { UserRoleRemoveOperation() }
}

struct UserRoleSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { UserRoleSearchOperation() }
}

struct UserRoleListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { UserRoleListOperation() }
}

struct UserRoleIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { UserRoleGetOperation() }
    var put: (any OperationRepresentable)? { UserRoleUpdateOperation() }
    var patch: (any OperationRepresentable)? { UserRolePatchOperation() }
}
