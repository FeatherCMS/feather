public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct NewsArticleListPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { NewsArticleListOperation() }

    public init() {}
}

public struct NewsArticleGetPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { NewsArticleGetOperation() }

    public init() {}
}
