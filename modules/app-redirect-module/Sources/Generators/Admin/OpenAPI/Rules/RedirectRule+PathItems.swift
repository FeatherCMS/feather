import FeatherOpenAPI

struct RedirectRulePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { RedirectRuleCreateOperation() }
    var delete: (any OperationRepresentable)? { RedirectRuleRemoveOperation() }
}

struct RedirectRuleSearchPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { RedirectRuleSearchOperation() }
}

struct RedirectRuleListPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { RedirectRuleListOperation() }
}

struct RedirectRuleIdPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { RedirectRuleGetOperation() }
    var put: (any OperationRepresentable)? { RedirectRuleUpdateOperation() }
    var patch: (any OperationRepresentable)? { RedirectRulePatchOperation() }
}
