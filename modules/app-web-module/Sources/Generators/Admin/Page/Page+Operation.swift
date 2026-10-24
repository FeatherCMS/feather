public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page {
    public protocol Operation: OperationRepresentable {}
    public protocol IdentifiableOperation: Operation {}
}

extension Page.Operation {
    public var tags: [any TagRepresentable] { [Page.Tag()] }
}

extension Page.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [Page.Parameters.ID().reference()]
    }
}
