import AppOpenAPI

struct SiteSettingsModel: Sendable {
    let title: String
    let description: String
    let language: String
    let noIndex: Bool
    let logoURL: String
    let logoDarkURL: String
    let metaImageURL: String
    let primaryColor: String
    let secondaryColor: String
    let tertiaryColor: String
    let primaryFont: String
    let secondaryFont: String
    let cssCodeInjection: String
    let javascriptCodeInjection: String

    init(
        schema: Components.Schemas.WebSiteSettingsSchema,
        publicOrigins: AppPublicOriginConfiguration
    ) {
        self.title = schema.title.isEmpty ? "Feather CMS" : schema.title
        self.description = schema.excerpt
        self.language = Self.normalizedLanguage(schema.locale)
        self.noIndex = schema.noIndex
        self.logoURL = Self.normalizedAssetURL(
            schema.logo,
            fallback: "\(publicOrigins.staticBaseURL)/theme/images/logos/logo.png",
            publicOrigins: publicOrigins
        )
        self.logoDarkURL = Self.normalizedAssetURL(
            schema.logoDark,
            fallback: logoURL,
            publicOrigins: publicOrigins
        )
        self.metaImageURL = Self.normalizedAssetURL(
            schema.metaImage,
            fallback: "\(publicOrigins.staticBaseURL)/theme/images/logos/logo-large.png",
            publicOrigins: publicOrigins
        )
        self.primaryColor = schema.primaryColor
        self.secondaryColor = schema.secondaryColor
        self.tertiaryColor = schema.tertiaryColor
        self.primaryFont = schema.primaryFont
        self.secondaryFont = schema.secondaryFont
        self.cssCodeInjection = schema.css
        self.javascriptCodeInjection = schema.js
    }
}

extension SiteSettingsModel {
    private static func normalizedLanguage(
        _ locale: String
    ) -> String {
        let trimmed = locale.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return "en-US"
        }
        let parts = trimmed
            .replacingOccurrences(of: "-", with: "_")
            .split(separator: "_")
            .map(String.init)
        guard let language = parts.first else {
            return "en-US"
        }
        if parts.count > 1 {
            return "\(language.lowercased())-\(parts[1].uppercased())"
        }
        return language.lowercased()
    }

    private static func normalizedAssetURL(
        _ value: String,
        fallback: String,
        publicOrigins: AppPublicOriginConfiguration
    ) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return fallback
        }
        if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") {
            return trimmed
        }
        var base = publicOrigins.staticBaseURL
        if !base.hasSuffix("/") {
            base += "/"
        }
        let path = trimmed.hasPrefix("/") ? String(trimmed.dropFirst()) : trimmed
        return base + path
    }
}
