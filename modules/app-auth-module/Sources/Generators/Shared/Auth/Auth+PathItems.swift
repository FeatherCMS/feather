public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct AuthLoginPathItems: PathItemRepresentable {
    public var post: (any OperationRepresentable)? { AuthLoginOperation() }

    public init() {}
}

public struct AuthLogoutPathItems: PathItemRepresentable {
    public var post: (any OperationRepresentable)? { AuthLogoutOperation() }

    public init() {}
}

public struct AuthMagicLinkPathItems: PathItemRepresentable {
    public var post: (any OperationRepresentable)? { AuthMagicLinkOperation() }

    public init() {}
}

public struct AuthMagicLinkVerifyPathItems: PathItemRepresentable {
    public var post: (any OperationRepresentable)? { AuthMagicLinkVerifyOperation() }

    public init() {}
}

public struct AuthMePathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { AuthMeOperation() }

    public init() {}
}
