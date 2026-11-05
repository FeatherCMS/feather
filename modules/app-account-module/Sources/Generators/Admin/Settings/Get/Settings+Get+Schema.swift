import FeatherOpenAPI

extension Settings.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountSettingsDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "language": Settings.Schemas.Language(),
                "timezone": Settings.Schemas.Timezone(),
                "pageSize": Settings.Schemas.PageSize(),
            ]
        }
    }
}
