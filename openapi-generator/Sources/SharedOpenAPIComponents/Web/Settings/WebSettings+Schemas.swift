import FeatherOpenAPI
import OpenAPIKit30

public struct WebSiteSettingsTitleField: StringSchemaRepresentable {
    public var example: String? = "Example Site"

    public init() {}
}

public struct WebSiteSettingsExcerptField: StringSchemaRepresentable {
    public var example: String? = "A concise site description."

    public init() {}
}

public struct WebSiteSettingsLocaleField: StringSchemaRepresentable {
    public var example: String? = "en_us"

    public init() {}
}

public struct WebSiteSettingsNoIndexField: BoolSchemaRepresentable {
    public var example: Bool? = false

    public init() {}
}

public struct WebSiteSettingsLogoField: StringSchemaRepresentable {
    public var example: String? = "/images/logo.svg"

    public init() {}
}

public struct WebSiteSettingsLogoDarkField: StringSchemaRepresentable {
    public var example: String? = "/images/logo-dark.svg"

    public init() {}
}

public struct WebSiteSettingsMetaImageField: StringSchemaRepresentable {
    public var example: String? = "/media/assets/default-meta-image.webp"

    public init() {}
}

public struct WebSiteSettingsPrimaryColorField: StringSchemaRepresentable {
    public var example: String? = "#1d4ed8"

    public init() {}
}

public struct WebSiteSettingsSecondaryColorField: StringSchemaRepresentable {
    public var example: String? = "#0f172a"

    public init() {}
}

public struct WebSiteSettingsTertiaryColorField: StringSchemaRepresentable {
    public var example: String? = "#e2e8f0"

    public init() {}
}

public struct WebSiteSettingsPrimaryFontField: StringSchemaRepresentable {
    public var example: String? = "Geist"

    public init() {}
}

public struct WebSiteSettingsSecondaryFontField: StringSchemaRepresentable {
    public var example: String? = "Merriweather"

    public init() {}
}

public struct WebSiteSettingsHomePageIDField: StringSchemaRepresentable {
    public var example: String? = "web_page_1"

    public init() {}
}

public struct WebSiteSettingsCSSField: StringSchemaRepresentable {
    public var example: String? = "body { }"

    public init() {}
}

public struct WebSiteSettingsJSField: StringSchemaRepresentable {
    public var example: String? = "console.log('web');"

    public init() {}
}

public struct WebSiteSettingsSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "title": WebSiteSettingsTitleField().reference(),
            "excerpt": WebSiteSettingsExcerptField().reference(),
            "locale": WebSiteSettingsLocaleField().reference(),
            "noIndex": WebSiteSettingsNoIndexField().reference(),
            "logo": WebSiteSettingsLogoField().reference(),
            "logoDark": WebSiteSettingsLogoDarkField().reference(),
            "metaImage": WebSiteSettingsMetaImageField().reference(),
            "primaryColor": WebSiteSettingsPrimaryColorField().reference(),
            "secondaryColor": WebSiteSettingsSecondaryColorField().reference(),
            "tertiaryColor": WebSiteSettingsTertiaryColorField().reference(),
            "primaryFont": WebSiteSettingsPrimaryFontField().reference(),
            "secondaryFont": WebSiteSettingsSecondaryFontField().reference(),
            "homePageId": WebSiteSettingsHomePageIDField().reference(
                required: false
            ),
            "css": WebSiteSettingsCSSField().reference(),
            "js": WebSiteSettingsJSField().reference(),
        ]
    }

    public init() {}
}
