import Domain

public struct Settings: Model {

    public enum Error: DomainError {
        case titleTooLong
        case excerptTooLong
        case cssTooLong
        case jsTooLong
        case logoTooLong
        case designValueTooLong
        case localeTooLong
        case timezoneTooLong
        case homePageIdTooLong
    }

    public let id: String
    public var logo: String
    public var logoDark: String
    public var metaImage: String
    public var primaryColor: String
    public var secondaryColor: String
    public var tertiaryColor: String
    public var primaryFont: String
    public var secondaryFont: String
    public var homePageId: String?
    public var locale: String
    public var timezone: String
    public var title: String
    public var excerpt: String
    public var noIndex: Bool
    public var css: String
    public var js: String

    package init(
        id: String = "web-settings",
        logo: String,
        logoDark: String,
        metaImage: String,
        primaryColor: String,
        secondaryColor: String,
        tertiaryColor: String,
        primaryFont: String,
        secondaryFont: String,
        homePageId: String?,
        locale: String,
        timezone: String,
        title: String,
        excerpt: String,
        noIndex: Bool,
        css: String,
        js: String
    ) {
        self.id = id
        self.logo = logo
        self.logoDark = logoDark
        self.metaImage = metaImage
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.tertiaryColor = tertiaryColor
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.homePageId = homePageId
        self.locale = locale
        self.timezone = timezone
        self.title = title
        self.excerpt = excerpt
        self.noIndex = noIndex
        self.css = css
        self.js = js
    }
}

public extension Settings {

    private static func validate(
        title: String,
        excerpt: String,
        css: String,
        js: String,
        logo: String,
        logoDark: String,
        metaImage: String,
        primaryColor: String,
        secondaryColor: String,
        tertiaryColor: String,
        primaryFont: String,
        secondaryFont: String,
        homePageId: String?,
        locale: String,
        timezone: String
    ) throws(Self.Error) {
        guard title.count < 255 else {
            throw .titleTooLong
        }
        guard excerpt.count < 4_000 else {
            throw .excerptTooLong
        }
        guard css.count < 100_000 else {
            throw .cssTooLong
        }
        guard js.count < 100_000 else {
            throw .jsTooLong
        }
        guard
            logo.count < 2_000,
            logoDark.count < 2_000,
            metaImage.count < 2_000
        else {
            throw .logoTooLong
        }
        guard
            primaryColor.count < 255,
            secondaryColor.count < 255,
            tertiaryColor.count < 255,
            primaryFont.count < 255,
            secondaryFont.count < 255
        else {
            throw .designValueTooLong
        }
        guard locale.count < 255 else {
            throw .localeTooLong
        }
        guard timezone.count < 255 else {
            throw .timezoneTooLong
        }
        guard (homePageId ?? "").count < 255 else {
            throw .homePageIdTooLong
        }
    }

    mutating func update(
        logo: String,
        logoDark: String,
        metaImage: String,
        primaryColor: String,
        secondaryColor: String,
        tertiaryColor: String,
        primaryFont: String,
        secondaryFont: String,
        homePageId: String?,
        locale: String,
        timezone: String,
        title: String,
        excerpt: String,
        noIndex: Bool,
        css: String,
        js: String
    ) throws(Self.Error) {
        try Self.validate(
            title: title,
            excerpt: excerpt,
            css: css,
            js: js,
            logo: logo,
            logoDark: logoDark,
            metaImage: metaImage,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            tertiaryColor: tertiaryColor,
            primaryFont: primaryFont,
            secondaryFont: secondaryFont,
            homePageId: homePageId,
            locale: locale,
            timezone: timezone
        )
        self.logo = logo
        self.logoDark = logoDark
        self.metaImage = metaImage
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.tertiaryColor = tertiaryColor
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.homePageId = homePageId
        self.locale = locale
        self.timezone = timezone
        self.title = title
        self.excerpt = excerpt
        self.noIndex = noIndex
        self.css = css
        self.js = js
    }
}
