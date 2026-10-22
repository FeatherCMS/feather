import FeatherOpenAPIGenerator
import OpenAPIKit30
public import FeatherOpenAPI

public protocol NewsCategoryOperation: OperationRepresentable {}

extension NewsCategoryOperation {
    public var tags: [any TagRepresentable] { [NewsContentTag()] }
}
