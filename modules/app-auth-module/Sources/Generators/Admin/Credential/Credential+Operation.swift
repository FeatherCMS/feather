public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential {
    public protocol Operation: BearerProtectedOperation {}
}

extension Credential.Operation {
    public var tags: [any TagRepresentable] { [Credential.Tag()] }
}

extension Credential {
    public protocol IdentifiableOperation: Operation {}
}

extension Credential.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [Credential.Parameters.ID().reference()]
    }
}
