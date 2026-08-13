import FeatherOpenAPI

struct AuthLoginPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthLoginOperation() }
}

struct AuthLogoutPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthLogoutOperation() }
}

struct AuthMagicLinkPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthMagicLinkOperation() }
}

struct AuthMagicLinkVerifyPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AuthMagicLinkVerifyOperation() }
}

struct AuthMePathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AuthMeOperation() }
}
