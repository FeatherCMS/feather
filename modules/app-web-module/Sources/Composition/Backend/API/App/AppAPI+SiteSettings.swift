import WebAppAPI
import WebApplication

extension WebBackend {
    public func webSiteSettings(
        _ input: Operations.WebSiteSettings.Input
    ) async throws -> Operations.WebSiteSettings.Output {
        let result = try await makeGetPublicSettings().execute()

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
