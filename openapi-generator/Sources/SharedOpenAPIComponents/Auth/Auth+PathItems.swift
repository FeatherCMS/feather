import FeatherOpenAPI

public struct AuthLoginPathItems: PathItemRepresentable {
    public var post: OperationRepresentable? { AuthLoginOperation() }

    public init() {}
}

public struct AuthLogoutPathItems: PathItemRepresentable {
    public var post: OperationRepresentable? { AuthLogoutOperation() }

    public init() {}
}

public struct AuthMagicLinkPathItems: PathItemRepresentable {
    public var post: OperationRepresentable? { AuthMagicLinkOperation() }

    public init() {}
}

public struct AuthMagicLinkVerifyPathItems: PathItemRepresentable {
    public var post: OperationRepresentable? { AuthMagicLinkVerifyOperation() }

    public init() {}
}

public struct AuthMePathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { AuthMeOperation() }

    public init() {}
}
