import FeatherOpenAPI

extension Settings.Schemas {
    struct Excerpt: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsExcerptField" }
        var example: String? { "A concise site description." }
    }
}
