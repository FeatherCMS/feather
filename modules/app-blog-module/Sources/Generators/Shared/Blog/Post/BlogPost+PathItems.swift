import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct BlogPostListPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { BlogPostListOperation() }

    public init() {}
}

public struct BlogPostGetPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { BlogPostGetOperation() }

    public init() {}
}
