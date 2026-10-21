import FeatherOpenAPI

struct AuthLoginPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthLoginOperation() }
}

struct AuthLogoutPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthLogoutOperation() }
}

struct AuthMagicLinkPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthMagicLinkOperation() }
}

struct AuthMagicLinkVerifyPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AuthMagicLinkVerifyOperation() }
}

struct AuthMePathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AuthMeOperation() }
}
