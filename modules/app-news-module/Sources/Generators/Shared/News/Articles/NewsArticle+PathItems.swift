import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct NewsArticleListPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { NewsArticleListOperation() }

    public init() {}
}

public struct NewsArticleGetPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { NewsArticleGetOperation() }

    public init() {}
}
