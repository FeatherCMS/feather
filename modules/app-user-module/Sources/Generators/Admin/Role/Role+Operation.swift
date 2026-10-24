public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

extension Role {
    public protocol Operation: BearerProtectedOperation {}
    public protocol IdentifiableOperation: Operation {}
}

extension Role.Operation {
    public var tags: [any TagRepresentable] { [Role.Tag()] }
}

extension Role.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [Role.Parameters.ID().reference()]
    }
}
