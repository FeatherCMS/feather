import FeatherOpenAPI
import OpenAPIKit30

struct WebSettingsIdField: StringSchemaRepresentable {
    var example: String? = "web-settings"
}

struct WebSettingsLogoField: StringSchemaRepresentable {
    var example: String? = "/images/logo.svg"
}

struct WebSettingsLogoDarkField: StringSchemaRepresentable {
    var example: String? = "/images/logo-dark.svg"
}

struct WebSettingsMetaImageField: StringSchemaRepresentable {
    var example: String? = "/media/assets/default-meta-image.webp"
}

struct WebSettingsPrimaryColorField: StringSchemaRepresentable {
    var example: String? = "#1d4ed8"
}

struct WebSettingsSecondaryColorField: StringSchemaRepresentable {
    var example: String? = "#0f172a"
}

struct WebSettingsTertiaryColorField: StringSchemaRepresentable {
    var example: String? = "#e2e8f0"
}

struct WebSettingsPrimaryFontField: StringSchemaRepresentable {
    var example: String? = "Geist"
}

struct WebSettingsSecondaryFontField: StringSchemaRepresentable {
    var example: String? = "Merriweather"
}

struct WebSettingsHomePageIDField: StringSchemaRepresentable {
    var example: String? = "web_page_1"
}

struct WebSettingsLocaleField: StringSchemaRepresentable {
    var example: String? = "en_us"
}

struct WebSettingsTimezoneField: StringSchemaRepresentable {
    var example: String? = "utc"
}

struct WebSettingsTitleField: StringSchemaRepresentable {
    var example: String? = "Example Site"
}

struct WebSettingsExcerptField: StringSchemaRepresentable {
    var example: String? = "A concise site description."
}

struct WebSettingsNoIndexField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct WebSettingsCSSField: StringSchemaRepresentable {
    var example: String? = "body { }"
}

struct WebSettingsJSField: StringSchemaRepresentable {
    var example: String? = "console.log('web');"
}

struct WebSettingsUpdateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "logo": WebSettingsLogoField(),
            "logoDark": WebSettingsLogoDarkField(),
            "metaImage": WebSettingsMetaImageField(),
            "primaryColor": WebSettingsPrimaryColorField(),
            "secondaryColor": WebSettingsSecondaryColorField(),
            "tertiaryColor": WebSettingsTertiaryColorField(),
            "primaryFont": WebSettingsPrimaryFontField(),
            "secondaryFont": WebSettingsSecondaryFontField(),
            "homePageId": WebSettingsHomePageIDField().reference(
                required: false
            ),
            "locale": WebSettingsLocaleField(),
            "timezone": WebSettingsTimezoneField(),
            "title": WebSettingsTitleField(),
            "excerpt": WebSettingsExcerptField(),
            "noIndex": WebSettingsNoIndexField(),
            "css": WebSettingsCSSField(),
            "js": WebSettingsJSField(),
        ]
    }
}

struct WebSettingsDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebSettingsIdField(),
            "logo": WebSettingsLogoField(),
            "logoDark": WebSettingsLogoDarkField(),
            "metaImage": WebSettingsMetaImageField(),
            "primaryColor": WebSettingsPrimaryColorField(),
            "secondaryColor": WebSettingsSecondaryColorField(),
            "tertiaryColor": WebSettingsTertiaryColorField(),
            "primaryFont": WebSettingsPrimaryFontField(),
            "secondaryFont": WebSettingsSecondaryFontField(),
            "homePageId": WebSettingsHomePageIDField().reference(
                required: false
            ),
            "locale": WebSettingsLocaleField(),
            "timezone": WebSettingsTimezoneField(),
            "title": WebSettingsTitleField(),
            "excerpt": WebSettingsExcerptField(),
            "noIndex": WebSettingsNoIndexField(),
            "css": WebSettingsCSSField(),
            "js": WebSettingsJSField(),
        ]
    }
}
