public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct BlogAuthorListPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { BlogAuthorListOperation() }

    public init() {}
}

public struct BlogAuthorGetPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { BlogAuthorGetOperation() }

    public init() {}
}
