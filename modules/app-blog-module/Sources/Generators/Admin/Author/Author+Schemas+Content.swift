import FeatherOpenAPI

extension Author.Schemas {
    struct Content: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorContentField" }
        var example: String? = "Author biography."
    }
}
