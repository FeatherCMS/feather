import FeatherOpenAPI

extension Settings.Schemas {
    struct PostListPath: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogSettingsPostListPathField" }
        var example: String? = "blog"
    }
}
