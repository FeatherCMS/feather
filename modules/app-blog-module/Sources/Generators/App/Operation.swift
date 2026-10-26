public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public protocol BlogOperation: OperationRepresentable {}

extension BlogOperation {
    public var tags: [any TagRepresentable] { [Blog.Tag()] }
}
