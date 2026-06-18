import FeatherOpenAPI

public struct BlogAuthorListPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { BlogAuthorListOperation() }

    public init() {}
}

public struct BlogAuthorGetPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { BlogAuthorGetOperation() }

    public init() {}
}
