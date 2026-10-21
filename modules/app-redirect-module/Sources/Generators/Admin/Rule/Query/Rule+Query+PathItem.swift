import FeatherOpenAPI

struct RedirectRuleQueryPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { RedirectRuleQueryOperation() }
}
