import FeatherOpenAPI

struct SystemPermissionPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { SystemPermissionCreateOperation() }
    var delete: OperationRepresentable? {
        SystemPermissionBulkDeleteOperation()
    }
}

struct SystemPermissionSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { SystemPermissionSearchOperation() }
}

struct SystemPermissionFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemPermissionFiltersOperation() }
}

struct SystemPermissionIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemPermissionGetOperation() }
    var put: OperationRepresentable? { SystemPermissionUpdateOperation() }
    var patch: OperationRepresentable? { SystemPermissionPatchOperation() }
    var delete: OperationRepresentable? { SystemPermissionDeleteOperation() }
}
