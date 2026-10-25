import FeatherOpenAPI

extension Rule.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "RedirectRuleResponse" }
        var description: String = "Redirect rule response"
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
