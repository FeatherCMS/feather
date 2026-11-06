import FeatherOpenAPI

extension AuthorLink.Schemas {
    struct Permission: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkPermissionField" }
        var example: String? = ""
    }
}
