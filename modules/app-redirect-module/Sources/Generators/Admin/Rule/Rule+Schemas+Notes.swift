import FeatherOpenAPI

extension Rule.Schemas {
    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleNotesField" }
        var example: String? = "Legacy homepage redirect."
    }
}
