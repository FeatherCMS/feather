import FeatherOpenAPI

struct RedirectRuleIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { RedirectRuleGetOperation() }
    var put: (any OperationRepresentable)? { RedirectRuleUpdateOperation() }
    var patch: (any OperationRepresentable)? { RedirectRulePatchOperation() }
}
