import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct RedirectRuleGetPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { RedirectRuleGetOperation() }

    public init() {}
}
