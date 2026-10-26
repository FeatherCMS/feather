import FeatherOpenAPI

extension Settings.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsUpdateSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Settings.Schemas.ID(),
                "logo": Settings.Schemas.Logo(),
                "logoDark": Settings.Schemas.LogoDark(),
                "metaImage": Settings.Schemas.MetaImage(),
                "primaryColor": Settings.Schemas.PrimaryColor(),
                "secondaryColor": Settings.Schemas.SecondaryColor(),
                "tertiaryColor": Settings.Schemas.TertiaryColor(),
                "primaryFont": Settings.Schemas.PrimaryFont(),
                "secondaryFont": Settings.Schemas.SecondaryFont(),
                "homePageId": Settings.Schemas.HomePageID().reference(required: false),
                "locale": Settings.Schemas.Locale(),
                "timezone": Settings.Schemas.Timezone(),
                "title": Settings.Schemas.Title(),
                "excerpt": Settings.Schemas.Excerpt(),
                "noIndex": Settings.Schemas.NoIndex(),
                "css": Settings.Schemas.CSS(),
                "js": Settings.Schemas.JS(),
            ]
        }
    }
}
