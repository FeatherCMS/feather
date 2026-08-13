import FeatherOpenAPI

struct AuthMagicLinkManagementPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthMagicLinkCreateOperation() }
    var delete: OperationRepresentable? { AuthMagicLinkBulkDeleteOperation() }
}

struct AuthMagicLinkSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthMagicLinkSearchOperation() }
}

struct AuthMagicLinkFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthMagicLinkFiltersOperation() }
}

struct AuthMagicLinkIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthMagicLinkGetOperation() }
    var put: OperationRepresentable? { AuthMagicLinkUpdateOperation() }
    var patch: OperationRepresentable? { AuthMagicLinkPatchOperation() }
    var delete: OperationRepresentable? { AuthMagicLinkDeleteOperation() }
}
