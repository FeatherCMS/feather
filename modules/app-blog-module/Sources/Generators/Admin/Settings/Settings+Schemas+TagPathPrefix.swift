import FeatherOpenAPI

extension Settings.Schemas {
    struct TagPathPrefix: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogSettingsTagPathPrefixField" }
        var example: String? = "tags"
    }
}
