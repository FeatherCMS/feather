import FeatherOpenAPI

struct UserRolePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserRoleCreateOperation() }
    var delete: OperationRepresentable? { UserRoleBulkDeleteOperation() }
}

struct UserRoleSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserRoleSearchOperation() }
}

struct UserRoleFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserRoleFiltersOperation() }
}

struct UserRoleIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserRoleGetOperation() }
    var put: OperationRepresentable? { UserRoleUpdateOperation() }
    var patch: OperationRepresentable? { UserRolePatchOperation() }
    var delete: OperationRepresentable? { UserRoleDeleteOperation() }
}
