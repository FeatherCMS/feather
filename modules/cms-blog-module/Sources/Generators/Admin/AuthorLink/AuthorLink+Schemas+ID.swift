import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkIdField" }
        var example: String? = "wmi_home"
    }
}
