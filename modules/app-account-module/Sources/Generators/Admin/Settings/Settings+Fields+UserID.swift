import FeatherOpenAPI

extension Settings.Fields {
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountSettingsUserIDField" }
    }
}
