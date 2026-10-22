public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol NewsArticleOperation: OperationRepresentable {}

extension NewsArticleOperation {
    public var tags: [any TagRepresentable] { [NewsContentTag()] }
}
