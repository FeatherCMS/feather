import FeatherOpenAPI

extension Settings.Schemas {
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountSettingsUserIDField" }
    }
}
