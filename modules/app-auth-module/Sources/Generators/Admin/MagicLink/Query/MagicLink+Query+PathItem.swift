import FeatherOpenAPI

struct AuthMagicLinkQueryPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthMagicLinkQueryOperation() }
}
