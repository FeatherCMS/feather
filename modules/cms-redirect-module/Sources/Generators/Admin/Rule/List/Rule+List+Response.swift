import FeatherOpenAPI

extension Rule.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "RedirectRuleListResponse" }
        var description: String = "RedirectRule list response"
        var schema = Schema().reference()
    }
}
