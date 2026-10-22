import FeatherOpenAPI

struct AuthMagicLinkManagementPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthMagicLinkListOperation() }
    var post: (any OperationRepresentable)? { AuthMagicLinkCreateOperation() }
    var delete: (any OperationRepresentable)? { AuthMagicLinkRemoveOperation() }
}

struct AuthMagicLinkQueryPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthMagicLinkQueryOperation() }
}

struct AuthMagicLinkIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthMagicLinkGetOperation() }
    var put: (any OperationRepresentable)? { AuthMagicLinkUpdateOperation() }
    var patch: (any OperationRepresentable)? { AuthMagicLinkPatchOperation() }
}
