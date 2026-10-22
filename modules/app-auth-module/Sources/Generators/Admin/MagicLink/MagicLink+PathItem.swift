import FeatherOpenAPI

struct AuthMagicLinkManagementPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthMagicLinkListOperation() }
    var post: (any OperationRepresentable)? { AuthMagicLinkCreateOperation() }
    var delete: (any OperationRepresentable)? { AuthMagicLinkRemoveOperation() }
}
