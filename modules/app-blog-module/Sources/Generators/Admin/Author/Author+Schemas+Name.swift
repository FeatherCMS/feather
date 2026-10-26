import FeatherOpenAPI

extension Author.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorNameField" }
        var example: String? = "Header menu"
    }
}
