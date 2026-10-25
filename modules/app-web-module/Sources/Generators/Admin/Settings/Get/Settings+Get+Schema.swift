import FeatherOpenAPI

extension Settings.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsDetailSchema" }
        var propertyMap: SchemaMap {
            [
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
