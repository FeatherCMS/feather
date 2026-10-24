import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import WebModule

extension AdminAPIGateway {

    public func settingsPut(
        _ input: Operations.SettingsPut.Input
    ) async throws -> Operations.SettingsPut.Output {
        let body: Components.Schemas.SettingsUpdateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeEditSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                logo: body.logo,
                logoDark: body.logoDark,
                metaImage: body.metaImage,
                primaryColor: body.primaryColor,
                secondaryColor: body.secondaryColor,
                tertiaryColor: body.tertiaryColor,
                primaryFont: body.primaryFont,
                secondaryFont: body.secondaryFont,
                homePageId: (body.homePageId ?? "").emptyToNil,
                locale: body.locale,
                timezone: body.timezone,
                title: body.title,
                excerpt: body.excerpt,
                noIndex: body.noIndex,
                css: body.css,
                js: body.js
            )
        )

        return .ok(.init(body: .json(map(result))))
    }

    private func map(
        _ detail: Settings.Edit.Output
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
