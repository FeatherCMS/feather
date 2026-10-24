public import FeatherApplication
import WebDomain
public import WebModule

extension Settings.Edit {
    public struct Output: DTO {
        public let logo: String
        public let logoDark: String
        public let metaImage: String
        public let primaryColor: String
        public let secondaryColor: String
        public let tertiaryColor: String
        public let primaryFont: String
        public let secondaryFont: String
        public let homePageId: String?
        public let locale: String
        public let timezone: String
        public let title: String
        public let excerpt: String
        public let noIndex: Bool
        public let css: String
        public let js: String

        init(model: Settings.Model) {
            self.logo = model.logo
            self.logoDark = model.logoDark
            self.metaImage = model.metaImage
            self.primaryColor = model.primaryColor
            self.secondaryColor = model.secondaryColor
            self.tertiaryColor = model.tertiaryColor
            self.primaryFont = model.primaryFont
            self.secondaryFont = model.secondaryFont
            self.homePageId = model.homePageId
            self.locale = model.locale
            self.timezone = model.timezone
            self.title = model.title
            self.excerpt = model.excerpt
            self.noIndex = model.noIndex
            self.css = model.css
            self.js = model.js
        }
    }
}
