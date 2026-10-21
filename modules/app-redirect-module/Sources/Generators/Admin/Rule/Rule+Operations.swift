public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

public protocol RedirectRuleOperation: BearerProtectedOperation {
    var operationId: String? { get }
}

extension RedirectRuleOperation {
    public var tags: [any TagRepresentable] { [RedirectRuleTag()] }
}

public protocol RedirectRuleIDOperation: RedirectRuleOperation {}

extension RedirectRuleIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [RedirectRuleIdParameter().reference()]
    }
}
