import FeatherOpenAPI

struct AuthMagicLinkIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthMagicLinkGetOperation() }
    var put: (any OperationRepresentable)? { AuthMagicLinkUpdateOperation() }
    var patch: (any OperationRepresentable)? { AuthMagicLinkPatchOperation() }
}
