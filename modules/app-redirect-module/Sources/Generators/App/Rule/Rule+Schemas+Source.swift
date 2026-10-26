import FeatherOpenAPI

extension Rule.Schemas {
    struct Source: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectSourceField" }
        var example: String? { "/from-here/" }
    }
}
