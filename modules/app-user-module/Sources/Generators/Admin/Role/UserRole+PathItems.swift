import FeatherOpenAPI

struct UserRolePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserRoleCreateOperation() }
    var delete: OperationRepresentable? { UserRoleDeleteOperation() }
}

struct UserRoleSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserRoleSearchOperation() }
}

struct UserRoleListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserRoleListOperation() }
}

struct UserRoleIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserRoleGetOperation() }
    var put: OperationRepresentable? { UserRoleUpdateOperation() }
    var patch: OperationRepresentable? { UserRolePatchOperation() }
}
