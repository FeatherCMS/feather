import FeatherOpenAPI

extension Settings.Schemas {
    struct AuthorListPath: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogSettingsAuthorListPathField" }
        var example: String? = "authors"
    }
}
