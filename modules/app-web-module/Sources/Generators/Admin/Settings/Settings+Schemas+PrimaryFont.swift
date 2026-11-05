import FeatherOpenAPI

extension Settings.Schemas {
    struct PrimaryFont: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsPrimaryFontField" }
        var example: String? { "Geist" }
    }
}
