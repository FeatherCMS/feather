import FeatherOpenAPI

struct RedirectRulePathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { RedirectRuleListOperation() }
    var post: (any OperationRepresentable)? { RedirectRuleCreateOperation() }
    var delete: (any OperationRepresentable)? { RedirectRuleRemoveOperation() }
}
