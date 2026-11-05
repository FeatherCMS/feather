import FeatherOpenAPI

extension Settings.Schemas {
    struct JS: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsJSField" }
        var example: String? { "console.log('web');" }
    }
}
