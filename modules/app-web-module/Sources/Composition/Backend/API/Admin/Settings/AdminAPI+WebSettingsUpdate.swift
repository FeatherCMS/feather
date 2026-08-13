import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webSettingsUpdate(
        _ input: Operations.WebSettingsUpdate.Input
    ) async throws -> Operations.WebSettingsUpdate.Output {
        let body: Components.Schemas.WebSettingsUpdateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = makeEditSettings()
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
}
