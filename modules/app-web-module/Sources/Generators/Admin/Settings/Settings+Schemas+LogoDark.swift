import FeatherOpenAPI

extension Settings.Schemas {
    struct LogoDark: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsLogoDarkField" }
        var example: String? { "/images/logo-dark.svg" }
    }
}
