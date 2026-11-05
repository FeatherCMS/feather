import FeatherOpenAPI

extension Settings.Schemas {
    struct Title: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsTitleField" }
        var example: String? { "Example Site" }
    }
}
