public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Permission {
    public protocol Operation: OperationRepresentable {}
    public protocol IdentifiableOperation: Operation {}
}

extension Permission.Operation {
    public var tags: [any TagRepresentable] { [Permission.Tag()] }
}

extension Permission.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [Permission.Parameters.ID().reference()]
    }
}
