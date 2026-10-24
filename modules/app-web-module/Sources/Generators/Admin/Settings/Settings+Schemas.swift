public import FeatherOpenAPI
import OpenAPIKit30

struct SettingsIdField: StringSchemaRepresentable {
    var example: String? = "web-settings"
}

struct SettingsLogoField: StringSchemaRepresentable {
    var example: String? = "/images/logo.svg"
}

struct SettingsLogoDarkField: StringSchemaRepresentable {
    var example: String? = "/images/logo-dark.svg"
}

struct SettingsMetaImageField: StringSchemaRepresentable {
    var example: String? =
        "/public/12/34/56789/originals/default-meta-image.webp"
}

struct SettingsPrimaryColorField: StringSchemaRepresentable {
    var example: String? = "#1d4ed8"
}

struct SettingsSecondaryColorField: StringSchemaRepresentable {
    var example: String? = "#0f172a"
}

struct SettingsTertiaryColorField: StringSchemaRepresentable {
    var example: String? = "#e2e8f0"
}

struct SettingsPrimaryFontField: StringSchemaRepresentable {
    var example: String? = "Geist"
}

struct SettingsSecondaryFontField: StringSchemaRepresentable {
    var example: String? = "Merriweather"
}

struct SettingsHomePageIDField: StringSchemaRepresentable {
    var example: String? = "web_page_1"
}

struct SettingsLocaleField: StringSchemaRepresentable {
    var example: String? = "en-US"
}

struct SettingsTimezoneField: StringSchemaRepresentable {
    var example: String? = "utc"
}

struct SettingsTitleField: StringSchemaRepresentable {
    var example: String? = "Example Site"
}

struct SettingsExcerptField: StringSchemaRepresentable {
    var example: String? = "A concise site description."
}

struct SettingsNoIndexField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct SettingsCSSField: StringSchemaRepresentable {
    var example: String? = "body { }"
}

struct SettingsJSField: StringSchemaRepresentable {
    var example: String? = "console.log('web');"
}

struct SettingsUpdateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SettingsIdField(),
            "logo": SettingsLogoField(),
            "logoDark": SettingsLogoDarkField(),
            "metaImage": SettingsMetaImageField(),
            "primaryColor": SettingsPrimaryColorField(),
            "secondaryColor": SettingsSecondaryColorField(),
            "tertiaryColor": SettingsTertiaryColorField(),
            "primaryFont": SettingsPrimaryFontField(),
            "secondaryFont": SettingsSecondaryFontField(),
            "homePageId": SettingsHomePageIDField()
                .reference(
                    required: false
                ),
            "locale": SettingsLocaleField(),
            "timezone": SettingsTimezoneField(),
            "title": SettingsTitleField(),
            "excerpt": SettingsExcerptField(),
            "noIndex": SettingsNoIndexField(),
            "css": SettingsCSSField(),
            "js": SettingsJSField(),
        ]
    }
}

struct SettingsDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "logo": SettingsLogoField(),
            "logoDark": SettingsLogoDarkField(),
            "metaImage": SettingsMetaImageField(),
            "primaryColor": SettingsPrimaryColorField(),
            "secondaryColor": SettingsSecondaryColorField(),
            "tertiaryColor": SettingsTertiaryColorField(),
            "primaryFont": SettingsPrimaryFontField(),
            "secondaryFont": SettingsSecondaryFontField(),
            "homePageId": SettingsHomePageIDField()
                .reference(
                    required: false
                ),
            "locale": SettingsLocaleField(),
            "timezone": SettingsTimezoneField(),
            "title": SettingsTitleField(),
            "excerpt": SettingsExcerptField(),
            "noIndex": SettingsNoIndexField(),
            "css": SettingsCSSField(),
            "js": SettingsJSField(),
        ]
    }
}
