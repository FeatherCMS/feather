public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

public protocol AuthMagicLinkOperation: BearerProtectedOperation {}

extension AuthMagicLinkOperation {
    public var tags: [any TagRepresentable] { [AuthMagicLinkTag()] }
}

public protocol AuthMagicLinkIdOperation: AuthMagicLinkOperation {}

extension AuthMagicLinkIdOperation {
    public var parameters: [any ParameterRepresentable] {
        [AuthMagicLinkIdParameter().reference()]
    }
}
