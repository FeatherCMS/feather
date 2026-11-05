import FeatherOpenAPI

extension Rule.Schemas {
    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleSearchField" }
        var example: String? = "/old-home"
    }
}
