import FeatherOpenAPI

extension Post.Schemas {
    struct Content: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostContentField" }
        var example: String? = "<h1>Homepage</h1>"
    }
}
