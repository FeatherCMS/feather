import FeatherOpenAPI

extension Settings.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsIdField" }
        var example: String? { "web-settings" }
    }
}
