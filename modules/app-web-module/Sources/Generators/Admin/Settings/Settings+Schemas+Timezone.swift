import FeatherOpenAPI

extension Settings.Schemas {
    struct Timezone: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsTimezoneField" }
        var example: String? { "utc" }
    }
}
