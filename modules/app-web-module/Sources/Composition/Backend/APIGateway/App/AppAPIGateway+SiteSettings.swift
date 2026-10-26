public import WebAppAPI
import WebApplication

extension AppAPIGateway {
    public func siteSettings(
        _ input: Operations.SiteSettings.Input
    ) async throws -> Operations.SiteSettings.Output {
        let result = try await useCases.makeDetailPublicSettings().execute()

        return .ok(
            .init(
                body: .json(
                    .init(
                        title: result.title,
                        excerpt: result.excerpt,
                        locale: result.locale,
                        noIndex: result.noIndex,
                        logo: result.logo,
                        logoDark: result.logoDark,
                        metaImage: result.metaImage,
                        primaryColor: result.primaryColor,
                        secondaryColor: result.secondaryColor,
                        tertiaryColor: result.tertiaryColor,
                        primaryFont: result.primaryFont,
                        secondaryFont: result.secondaryFont,
                        homePageId: result.homePageId,
                        css: result.css,
                        js: result.js
                    )
                )
            )
        )
    }
}
