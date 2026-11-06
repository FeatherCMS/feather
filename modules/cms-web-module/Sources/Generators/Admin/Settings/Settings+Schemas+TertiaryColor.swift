import FeatherOpenAPI

extension Settings.Schemas {
    struct TertiaryColor: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsTertiaryColorField" }
        var example: String? { "#e2e8f0" }
    }
}
