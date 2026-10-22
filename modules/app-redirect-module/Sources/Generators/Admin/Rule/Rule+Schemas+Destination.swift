import FeatherOpenAPI

extension Rule.Schemas {
    struct Destination: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleDestinationField" }
        var example: String? = "/new-home"
    }
}
