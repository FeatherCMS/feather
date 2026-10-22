import FeatherOpenAPI

extension Settings.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountSettingsDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "language": Settings.Fields.Language(),
                "timezone": Settings.Fields.Timezone(),
                "pageSize": Settings.Fields.PageSize(),
            ]
        }
    }
}
