import FeatherOpenAPI

struct RedirectRulePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { RedirectRuleCreateOperation() }
    var delete: OperationRepresentable? { RedirectRuleBulkDeleteOperation() }
}

struct RedirectRuleSearchPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { RedirectRuleSearchOperation() }
}

struct RedirectRuleFiltersPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { RedirectRuleFiltersOperation() }
}

struct RedirectRuleIdPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { RedirectRuleGetOperation() }
    var put: OperationRepresentable? { RedirectRuleUpdateOperation() }
    var patch: OperationRepresentable? { RedirectRulePatchOperation() }
    var delete: OperationRepresentable? { RedirectRuleDeleteOperation() }
}
