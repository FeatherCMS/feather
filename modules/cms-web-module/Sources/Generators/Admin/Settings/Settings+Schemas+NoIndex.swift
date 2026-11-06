import FeatherOpenAPI

extension Settings.Schemas {
    struct NoIndex: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsNoIndexField" }
        var example: Bool? { false }
    }
}
