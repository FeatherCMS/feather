import FeatherOpenAPI

extension Settings.Schemas {
    struct CSS: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsCSSField" }
        var example: String? { "body { }" }
    }
}
