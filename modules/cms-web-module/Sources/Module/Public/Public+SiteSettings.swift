extension Public {
    public struct SiteSettings: Sendable {
        public let title: String
        public let excerpt: String
        public let locale: String
        public let timezone: String
        public let noIndex: Bool
        public let logo: String
        public let logoDark: String
        public let metaImage: String
        public let primaryColor: String
        public let secondaryColor: String
        public let tertiaryColor: String
        public let primaryFont: String
        public let secondaryFont: String
        public let trailingSlashBehavior: String
        public let css: String
        public let js: String

        public init(
            title: String,
            excerpt: String,
            locale: String,
            timezone: String,
            noIndex: Bool,
            logo: String,
            logoDark: String,
            metaImage: String,
            primaryColor: String,
            secondaryColor: String,
            tertiaryColor: String,
            primaryFont: String,
            secondaryFont: String,
            trailingSlashBehavior: String,
            css: String,
            js: String
        ) {
            self.title = title
            self.excerpt = excerpt
            self.locale = locale
            self.timezone = timezone
            self.noIndex = noIndex
            self.logo = logo
            self.logoDark = logoDark
            self.metaImage = metaImage
            self.primaryColor = primaryColor
            self.secondaryColor = secondaryColor
            self.tertiaryColor = tertiaryColor
            self.primaryFont = primaryFont
            self.secondaryFont = secondaryFont
            self.trailingSlashBehavior = trailingSlashBehavior
            self.css = css
            self.js = js
        }
    }
}
