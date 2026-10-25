import FeatherOpenAPI

extension Settings.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountSettingsUpdateSchema" }
        var propertyMap: SchemaMap {
            [
                "language": Settings.Schemas.Language(),
                "timezone": Settings.Schemas.Timezone(),
                "pageSize": Settings.Schemas.PageSize(),
            ]
        }
    }
}
