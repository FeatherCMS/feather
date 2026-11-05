import FeatherOpenAPI

extension Settings.Schemas {
    struct PrimaryColor: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsPrimaryColorField" }
        var example: String? { "#1d4ed8" }
    }
}
