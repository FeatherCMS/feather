import FeatherOpenAPI

extension Tag.Schemas {
    struct Content: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogTagContentField" }
        var example: String? = "<h1>Homepage</h1>"
    }
}
