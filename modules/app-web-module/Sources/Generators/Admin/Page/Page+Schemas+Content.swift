import FeatherOpenAPI

extension Page.Schemas {
    struct Content: StringSchemaRepresentable {
        var openAPIIdentifier: String { "PageContentField" }
        var example: String? = "<h1>Homepage</h1>"
    }
}
