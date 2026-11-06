import FeatherOpenAPI

extension Settings.Schemas {
    struct PostPathPrefix: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogSettingsPostPathPrefixField" }
        var example: String? = "posts"
    }
}
