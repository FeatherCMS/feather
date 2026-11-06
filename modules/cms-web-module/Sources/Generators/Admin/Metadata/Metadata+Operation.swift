public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata {
    public protocol Operation: OperationRepresentable {}
    public protocol IdentifiableOperation: Operation {}
}

extension Metadata.Operation {
    public var tags: [any TagRepresentable] { [Metadata.Tag()] }
}

extension Metadata.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [Metadata.Parameters.ID().reference()]
    }
}
