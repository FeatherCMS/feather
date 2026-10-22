public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

public protocol AuthCredentialOperation: BearerProtectedOperation {}

extension AuthCredentialOperation {
    public var tags: [any TagRepresentable] { [AuthCredentialTag()] }
}

public protocol AuthCredentialIdOperation: AuthCredentialOperation {}

extension AuthCredentialIdOperation {
    public var parameters: [any ParameterRepresentable] {
        [AuthCredentialIdParameter().reference()]
    }
}
