import FeatherOpenAPI

extension Tag.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogTagIdField" }
        var example: String? = "wp_home"
    }
}
