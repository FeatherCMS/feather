import FeatherOpenAPI

extension Post.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostIdField" }
        var example: String? = "wp_home"
    }
}
