import FeatherOpenAPI

extension Settings.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountSettingsUpdateSchema" }
        var propertyMap: SchemaMap {
            [
                "language": Settings.Fields.Language(),
                "timezone": Settings.Fields.Timezone(),
                "pageSize": Settings.Fields.PageSize(),
            ]
        }
    }
}
