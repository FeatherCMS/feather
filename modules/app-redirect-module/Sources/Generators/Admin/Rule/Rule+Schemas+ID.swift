import FeatherOpenAPI

extension Rule.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleIdField" }
        var example: String? = "rr_home_old"
    }
}
