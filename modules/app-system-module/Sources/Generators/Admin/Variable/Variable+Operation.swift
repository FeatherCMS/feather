public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variable {
    public protocol Operation: OperationRepresentable {}
    public protocol IdentifiableOperation: Operation {}
}

extension Variable.Operation {
    public var tags: [any TagRepresentable] { [Variable.Tag()] }
}

extension Variable.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [Variable.Parameters.ID().reference()]
    }
}
