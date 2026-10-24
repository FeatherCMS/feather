public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

extension Identity {
    public protocol Operation: BearerProtectedOperation {}
    public protocol IdentifiableOperation: Operation {}
}

extension Identity.Operation {
    public var tags: [any TagRepresentable] { [Identity.Tag()] }
}

extension Identity.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [Identity.Parameters.ID().reference()]
    }
}
