import FeatherOpenAPI

extension Settings.Schemas {
    struct SecondaryFont: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsSecondaryFontField" }
        var example: String? { "Merriweather" }
    }
}
