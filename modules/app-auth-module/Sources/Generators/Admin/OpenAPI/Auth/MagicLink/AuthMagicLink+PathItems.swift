import FeatherOpenAPI

struct AuthMagicLinkManagementPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthMagicLinkCreateOperation() }
    var delete: (any OperationRepresentable)? { AuthMagicLinkRemoveOperation() }
}

struct AuthMagicLinkSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthMagicLinkSearchOperation() }
}

struct AuthMagicLinkListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthMagicLinkListOperation() }
}

struct AuthMagicLinkIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthMagicLinkGetOperation() }
    var put: (any OperationRepresentable)? { AuthMagicLinkUpdateOperation() }
    var patch: (any OperationRepresentable)? { AuthMagicLinkPatchOperation() }
}
