import FeatherOpenAPI

extension Settings.Schemas {
    struct Locale: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsLocaleField" }
        var example: String? { "en-US" }
    }
}
