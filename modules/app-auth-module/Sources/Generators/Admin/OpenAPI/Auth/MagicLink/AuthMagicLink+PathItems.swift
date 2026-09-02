import FeatherOpenAPI

struct AuthMagicLinkManagementPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthMagicLinkCreateOperation() }
    var delete: OperationRepresentable? { AuthMagicLinkDeleteOperation() }
}

struct AuthMagicLinkSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthMagicLinkSearchOperation() }
}

struct AuthMagicLinkListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthMagicLinkListOperation() }
}

struct AuthMagicLinkIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthMagicLinkGetOperation() }
    var put: OperationRepresentable? { AuthMagicLinkUpdateOperation() }
    var patch: OperationRepresentable? { AuthMagicLinkPatchOperation() }
}
