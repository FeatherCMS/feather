import FeatherOpenAPI

struct SystemPermissionPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { SystemPermissionCreateOperation() }
    var delete: OperationRepresentable? {
        SystemPermissionDeleteOperation()
    }
}

struct SystemPermissionSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { SystemPermissionSearchOperation() }
}

struct SystemPermissionListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemPermissionListOperation() }
}

struct SystemPermissionIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { SystemPermissionGetOperation() }
    var put: OperationRepresentable? { SystemPermissionUpdateOperation() }
    var patch: OperationRepresentable? { SystemPermissionPatchOperation() }
}
