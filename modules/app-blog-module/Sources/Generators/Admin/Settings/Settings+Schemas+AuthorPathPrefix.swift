import FeatherOpenAPI

extension Settings.Schemas {
    struct AuthorPathPrefix: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogSettingsAuthorPathPrefixField" }
        var example: String? = "authors"
    }
}
