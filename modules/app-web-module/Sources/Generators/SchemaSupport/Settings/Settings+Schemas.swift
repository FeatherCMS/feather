public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public struct SiteSettingsTitleField: StringSchemaRepresentable {
    public var example: String? = "Example Site"

    public init() {}
}

public struct SiteSettingsExcerptField: StringSchemaRepresentable {
    public var example: String? = "A concise site description."

    public init() {}
}

public struct SiteSettingsLocaleField: StringSchemaRepresentable {
    public var example: String? = "en-US"

    public init() {}
}

public struct SiteSettingsNoIndexField: BoolSchemaRepresentable {
    public var example: Bool? = false

    public init() {}
}

public struct SiteSettingsLogoField: StringSchemaRepresentable {
    public var example: String? = "/images/logo.svg"

    public init() {}
}

public struct SiteSettingsLogoDarkField: StringSchemaRepresentable {
    public var example: String? = "/images/logo-dark.svg"

    public init() {}
}

public struct SiteSettingsMetaImageField: StringSchemaRepresentable {
    public var example: String? =
        "/public/12/34/56789/originals/default-meta-image.webp"

    public init() {}
}

public struct SiteSettingsPrimaryColorField: StringSchemaRepresentable {
    public var example: String? = "#1d4ed8"

    public init() {}
}

public struct SiteSettingsSecondaryColorField: StringSchemaRepresentable {
    public var example: String? = "#0f172a"

    public init() {}
}

public struct SiteSettingsTertiaryColorField: StringSchemaRepresentable {
    public var example: String? = "#e2e8f0"

    public init() {}
}

public struct SiteSettingsPrimaryFontField: StringSchemaRepresentable {
    public var example: String? = "Geist"

    public init() {}
}

public struct SiteSettingsSecondaryFontField: StringSchemaRepresentable {
    public var example: String? = "Merriweather"

    public init() {}
}

public struct SiteSettingsHomePageIDField: StringSchemaRepresentable {
    public var example: String? = "web_page_1"

    public init() {}
}

public struct SiteSettingsCSSField: StringSchemaRepresentable {
    public var example: String? = "body { }"

    public init() {}
}

public struct SiteSettingsJSField: StringSchemaRepresentable {
    public var example: String? = "console.log('web');"

    public init() {}
}

public struct SiteSettingsSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "title": SiteSettingsTitleField().reference(),
            "excerpt": SiteSettingsExcerptField().reference(),
            "locale": SiteSettingsLocaleField().reference(),
            "noIndex": SiteSettingsNoIndexField().reference(),
            "logo": SiteSettingsLogoField().reference(),
            "logoDark": SiteSettingsLogoDarkField().reference(),
            "metaImage": SiteSettingsMetaImageField().reference(),
            "primaryColor": SiteSettingsPrimaryColorField().reference(),
            "secondaryColor": SiteSettingsSecondaryColorField().reference(),
            "tertiaryColor": SiteSettingsTertiaryColorField().reference(),
            "primaryFont": SiteSettingsPrimaryFontField().reference(),
            "secondaryFont": SiteSettingsSecondaryFontField().reference(),
            "homePageId": SiteSettingsHomePageIDField()
                .reference(
                    required: false
                ),
            "css": SiteSettingsCSSField().reference(),
            "js": SiteSettingsJSField().reference(),
        ]
    }

    public init() {}
}
