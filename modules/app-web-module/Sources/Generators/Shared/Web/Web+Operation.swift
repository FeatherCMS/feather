public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public protocol WebOperation: OperationRepresentable {}

extension WebOperation {
    public var tags: [any TagRepresentable] { [WebContentTag()] }
}
