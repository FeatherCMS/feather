import FeatherOpenAPIGenerator
import OpenAPIKit30
public import FeatherOpenAPI

public protocol NewsArticleOperation: OperationRepresentable {}

extension NewsArticleOperation {
    public var tags: [any TagRepresentable] { [NewsContentTag()] }
}
