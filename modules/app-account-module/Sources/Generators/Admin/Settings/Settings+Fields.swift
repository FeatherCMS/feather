import FeatherOpenAPI

extension Settings.Fields {
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountSettingsUserIDField" }
    }

    struct Language: StringSchemaRepresentable {}
    struct Timezone: StringSchemaRepresentable {}
    struct PageSize: IntSchemaRepresentable {}
}
