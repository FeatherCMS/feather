import FeatherOpenAPI

extension Author.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorIdField" }
        var example: String? = "wm_header"
    }
}
