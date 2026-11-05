import FeatherOpenAPI

extension Rule.Schemas {
    struct StatusCode: IntSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleStatusCodeField" }
        var example: Int? = 301
        var enumValues: [Int]? = [301, 302, 307, 308]
    }
}
