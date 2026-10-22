public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink {
    public protocol Operation: BearerProtectedOperation {}
}

extension MagicLink.Operation {
    public var tags: [any TagRepresentable] { [MagicLink.Tag()] }
}

extension MagicLink {
    public protocol IdentifiableOperation: MagicLink.Operation {}
}

extension MagicLink.IdentifiableOperation {
    public var parameters: [any ParameterRepresentable] {
        [MagicLink.Parameters.ID().reference()]
    }
}
