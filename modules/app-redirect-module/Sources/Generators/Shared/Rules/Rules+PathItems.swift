public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct RedirectRuleGetPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { RedirectRuleGetOperation() }

    public init() {}
}
