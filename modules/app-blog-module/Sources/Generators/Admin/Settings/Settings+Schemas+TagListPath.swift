import FeatherOpenAPI

extension Settings.Schemas {
    struct TagListPath: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogSettingsTagListPathField" }
        var example: String? = "tags"
    }
}
