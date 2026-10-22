public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

public protocol UserIdentityOperation: BearerProtectedOperation {}

extension UserIdentityOperation {
    public var tags: [any TagRepresentable] { [UserIdentityTag()] }
}

public protocol UserIdentitySessionOperation: UserIdentityOperation {}

extension UserIdentitySessionOperation {
    public var parameters: [any ParameterRepresentable] {
        [UserIdentityIdParameter().reference()]
    }
}
