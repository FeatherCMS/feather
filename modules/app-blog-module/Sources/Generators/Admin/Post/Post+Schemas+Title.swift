import FeatherOpenAPI

extension Post.Schemas {
    struct Title: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostTitleField" }
        var example: String? = "Hello world"
    }
}
