public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct BlogPostListPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { BlogPostListOperation() }

    public init() {}
}

public struct BlogPostGetPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { BlogPostGetOperation() }

    public init() {}
}
