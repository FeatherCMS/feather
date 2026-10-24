import FeatherOpenAPI

extension Rule.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "RedirectRuleDetailResponse" }
        var description: String = "RedirectRule response"
        var schema = Schema().reference()
    }
}
