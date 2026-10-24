import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import WebModule

extension AdminAPIGateway {

    public func settingsGet(
        _ input: Operations.SettingsGet.Input
    ) async throws -> Operations.SettingsGet.Output {
        let useCase = useCases.makeGetSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )

        return .ok(.init(body: .json(map(result))))
    }

    private func map(
        _ detail: Settings.Detail.Output
    ) -> Components.Schemas.SettingsDetailSchema {
        .init(
            logo: detail.logo,
            logoDark: detail.logoDark,
            metaImage: detail.metaImage,
            primaryColor: detail.primaryColor,
            secondaryColor: detail.secondaryColor,
            tertiaryColor: detail.tertiaryColor,
            primaryFont: detail.primaryFont,
            secondaryFont: detail.secondaryFont,
            homePageId: detail.homePageId,
            locale: detail.locale,
            timezone: detail.timezone,
            title: detail.title,
            excerpt: detail.excerpt,
            noIndex: detail.noIndex,
            css: detail.css,
            js: detail.js
        )
    }
}
