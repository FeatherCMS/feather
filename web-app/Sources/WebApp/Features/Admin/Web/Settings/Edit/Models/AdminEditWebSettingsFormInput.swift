struct AdminEditWebSettingsFormInput: Codable, Sendable, Equatable, Hashable {
    enum CodingKeys: String, CodingKey {
        case logo
        case logoDark
        case metaImage
        case primaryColor
        case secondaryColor
        case tertiaryColor
        case primaryFont
        case secondaryFont
        case homePageId
        case locale
        case timezone
        case title
        case excerpt
        case noIndex
        case css
        case js
    }

    let logo: String
    let logoDark: String
    let metaImage: String
    let primaryColor: String
    let secondaryColor: String
    let tertiaryColor: String
    let primaryFont: String
    let secondaryFont: String
    let homePageId: String
    let locale: String
    let timezone: String
    let title: String
    let excerpt: String
    let noIndex: CheckboxFormInput
    let css: String
    let js: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.logo = try container.decode(String.self, forKey: .logo)
        self.logoDark = try container.decode(String.self, forKey: .logoDark)
        self.metaImage = try container.decode(String.self, forKey: .metaImage)
        self.primaryColor = try container.decode(
            String.self,
            forKey: .primaryColor
        )
        self.secondaryColor = try container.decode(
            String.self,
            forKey: .secondaryColor
        )
        self.tertiaryColor = try container.decode(
            String.self,
            forKey: .tertiaryColor
        )
        self.primaryFont = try container.decode(
            String.self,
            forKey: .primaryFont
        )
        self.secondaryFont = try container.decode(
            String.self,
            forKey: .secondaryFont
        )
        self.homePageId = try container.decode(String.self, forKey: .homePageId)
        self.locale = try container.decode(String.self, forKey: .locale)
        self.timezone = try container.decode(String.self, forKey: .timezone)
        self.title = try container.decode(String.self, forKey: .title)
        self.excerpt = try container.decode(String.self, forKey: .excerpt)
        self.noIndex =
            try container.decodeIfPresent(
                CheckboxFormInput.self,
                forKey: .noIndex
            ) ?? .init(value: false)
        self.css = try container.decode(String.self, forKey: .css)
        self.js = try container.decode(String.self, forKey: .js)
    }

    var normalizedLogo: String {
        Self.normalizeText(logo)
    }

    var normalizedLogoDark: String {
        Self.normalizeText(logoDark)
    }

    var normalizedTitle: String {
        Self.normalizeText(title)
    }

    var normalizedMetaImage: String {
        Self.normalizeText(metaImage)
    }

    var normalizedPrimaryColor: String {
        Self.normalizeText(primaryColor)
    }

    var normalizedSecondaryColor: String {
        Self.normalizeText(secondaryColor)
    }

    var normalizedTertiaryColor: String {
        Self.normalizeText(tertiaryColor)
    }

    var normalizedPrimaryFont: String {
        Self.normalizeText(primaryFont)
    }

    var normalizedSecondaryFont: String {
        Self.normalizeText(secondaryFont)
    }

    var normalizedHomePageId: String? {
        let trimmed = Self.normalizeText(homePageId)
        return trimmed.isEmpty ? nil : trimmed
    }

    var normalizedLocale: String {
        Self.normalizeText(locale)
    }

    var normalizedTimezone: String {
        Self.normalizeText(timezone)
    }

    var normalizedExcerpt: String {
        Self.normalizeText(excerpt)
    }

    var normalizedCSS: String {
        Self.normalizeCode(css)
    }

    var normalizedJS: String {
        Self.normalizeCode(js)
    }

    func validationErrors() -> [String: String] {
        [:]
    }

    private static func normalizeText(
        _ value: String
    ) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func normalizeCode(
        _ value: String
    ) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
