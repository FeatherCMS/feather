public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Job {
    public protocol Operation: OperationRepresentable {}
    public protocol IdentifiableOperation: Operation {}
}

extension Job.Operation {
    public var tags: [any TagRepresentable] { [Job.Tag()] }
}

extension Job.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [Job.Parameters.ID().reference()]
    }
}
