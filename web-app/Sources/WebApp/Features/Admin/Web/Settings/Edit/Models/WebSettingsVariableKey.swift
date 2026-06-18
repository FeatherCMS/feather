enum WebSettingsVariableKey: String, CaseIterable, Sendable {
    case logo = "web.site.logo"
    case logoDark = "web.site.logo_dark"
    case metaImage = "web.site.meta_image"
    case primaryColor = "web.site.primary_color"
    case secondaryColor = "web.site.secondary_color"
    case tertiaryColor = "web.site.tertiary_color"
    case primaryFont = "web.site.primary_font"
    case secondaryFont = "web.site.secondary_font"
    case homePageId = "web.site.home_page_id"
    case locale = "web.site.locale"
    case timezone = "web.site.timezone"
    case title = "web.site.title"
    case excerpt = "web.site.excerpt"
    case noIndex = "web.site.no_index"
    case css = "web.site.css"
    case js = "web.site.js"

    var fieldKey: String {
        switch self {
        case .logo:
            "logo"
        case .logoDark:
            "logoDark"
        case .metaImage:
            "metaImage"
        case .primaryColor:
            "primaryColor"
        case .secondaryColor:
            "secondaryColor"
        case .tertiaryColor:
            "tertiaryColor"
        case .primaryFont:
            "primaryFont"
        case .secondaryFont:
            "secondaryFont"
        case .homePageId:
            "homePageId"
        case .locale:
            "locale"
        case .timezone:
            "timezone"
        case .title:
            "title"
        case .excerpt:
            "excerpt"
        case .noIndex:
            "noIndex"
        case .css:
            "css"
        case .js:
            "js"
        }
    }

    var label: String {
        switch self {
        case .logo:
            "Site logo"
        case .logoDark:
            "Site logo (dark mode)"
        case .metaImage:
            "Default meta image"
        case .primaryColor:
            "Primary color"
        case .secondaryColor:
            "Secondary color"
        case .tertiaryColor:
            "Tertiary color"
        case .primaryFont:
            "Primary font"
        case .secondaryFont:
            "Secondary font"
        case .homePageId:
            "Home page"
        case .locale:
            "Locale"
        case .timezone:
            "Timezone"
        case .title:
            "Site title"
        case .excerpt:
            "Site excerpt"
        case .noIndex:
            "Prevent search indexing"
        case .css:
            "Global CSS"
        case .js:
            "Global JavaScript"
        }
    }

    var defaultValue: String {
        switch self {
        case .locale:
            "en_us"
        case .timezone:
            "utc"
        case .noIndex:
            "false"
        default:
            ""
        }
    }

    var defaultBoolValue: Bool {
        switch self {
        case .noIndex:
            false
        default:
            false
        }
    }

    var notes: String {
        switch self {
        case .logo:
            "Web settings: public site logo."
        case .logoDark:
            "Web settings: public site logo for dark mode."
        case .metaImage:
            "Web settings: default metadata image."
        case .primaryColor:
            "Web settings: primary color."
        case .secondaryColor:
            "Web settings: secondary color."
        case .tertiaryColor:
            "Web settings: tertiary color."
        case .primaryFont:
            "Web settings: primary font."
        case .secondaryFont:
            "Web settings: secondary font."
        case .homePageId:
            "Web settings: selected home page."
        case .locale:
            "Web settings: default locale."
        case .timezone:
            "Web settings: default timezone."
        case .title:
            "Web settings: public site title."
        case .excerpt:
            "Web settings: public site excerpt."
        case .noIndex:
            "Web settings: prevent search engine indexing."
        case .css:
            "Web settings: global CSS injection."
        case .js:
            "Web settings: global JavaScript injection."
        }
    }
}
