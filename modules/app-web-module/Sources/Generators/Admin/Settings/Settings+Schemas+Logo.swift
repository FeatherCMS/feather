import FeatherOpenAPI

extension Settings.Schemas {
    struct Logo: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsLogoField" }
        var example: String? { "/images/logo.svg" }
    }
}
