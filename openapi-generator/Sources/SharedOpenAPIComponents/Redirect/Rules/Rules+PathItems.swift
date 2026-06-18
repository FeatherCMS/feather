import FeatherOpenAPI

public struct RedirectRuleGetPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { RedirectRuleGetOperation() }

    public init() {}
}
