import FeatherOpenAPI

struct RedirectRulePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { RedirectRuleCreateOperation() }
    var delete: OperationRepresentable? { RedirectRuleDeleteOperation() }
}

struct RedirectRuleSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { RedirectRuleSearchOperation() }
}

struct RedirectRuleListPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { RedirectRuleListOperation() }
}

struct RedirectRuleIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { RedirectRuleGetOperation() }
    var put: OperationRepresentable? { RedirectRuleUpdateOperation() }
    var patch: OperationRepresentable? { RedirectRulePatchOperation() }
}
