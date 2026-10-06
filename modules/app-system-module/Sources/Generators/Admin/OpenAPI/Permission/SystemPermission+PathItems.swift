import FeatherOpenAPI

struct SystemPermissionPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        SystemPermissionCreateOperation()
    }
    var delete: (any OperationRepresentable)? {
        SystemPermissionRemoveOperation()
    }
}

struct SystemPermissionSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        SystemPermissionSearchOperation()
    }
}

struct SystemPermissionListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { SystemPermissionListOperation() }
}

struct SystemPermissionIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { SystemPermissionGetOperation() }
    var put: (any OperationRepresentable)? { SystemPermissionUpdateOperation() }
    var patch: (any OperationRepresentable)? {
        SystemPermissionPatchOperation()
    }
}
