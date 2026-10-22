public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol NewsCategoryOperation: OperationRepresentable {}

extension NewsCategoryOperation {
    public var tags: [any TagRepresentable] { [NewsContentTag()] }
}
