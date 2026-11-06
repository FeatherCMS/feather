import FeatherOpenAPI

extension Page.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "PageIdField" }
        var example: String? = "wp_home"
    }
}
