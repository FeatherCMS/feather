import FeatherOpenAPI

extension Settings.Schemas {
    struct SecondaryColor: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsSecondaryColorField" }
        var example: String? { "#0f172a" }
    }
}
