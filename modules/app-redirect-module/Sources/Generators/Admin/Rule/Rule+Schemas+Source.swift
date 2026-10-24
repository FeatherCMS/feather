import FeatherOpenAPI

extension Rule.Schemas {
    struct Source: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleSourceField" }
        var example: String? = "/old-home"
    }
}
