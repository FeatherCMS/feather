import FeatherOpenAPI

struct UserMagicLinkPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserMagicLinkCreateOperation() }
    var delete: OperationRepresentable? { UserMagicLinkBulkDeleteOperation() }
}

struct UserMagicLinkSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { UserMagicLinkSearchOperation() }
}

struct UserMagicLinkFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserMagicLinkFiltersOperation() }
}

struct UserMagicLinkIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { UserMagicLinkGetOperation() }
    var put: OperationRepresentable? { UserMagicLinkUpdateOperation() }
    var patch: OperationRepresentable? { UserMagicLinkPatchOperation() }
    var delete: OperationRepresentable? { UserMagicLinkDeleteOperation() }
}
