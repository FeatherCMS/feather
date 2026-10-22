public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public protocol APIOperation: OperationRepresentable {}

extension APIOperation {
    public var tags: [any TagRepresentable] { [ContentTag()] }
}
