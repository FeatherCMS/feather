public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity {
    public protocol Operation: BearerProtectedOperation {}
    public protocol IdentifiableOperation: Operation {}
}

extension Identity.Operation {
    public var tags: [any TagRepresentable] { [UserIdentityTag()] }
}

extension Identity.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [UserIdentityIdParameter().reference()]
    }
}
