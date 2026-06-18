import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webSettingsUpdate(
        _ input: Operations.WebSettingsUpdate.Input
    ) async throws -> Operations.WebSettingsUpdate.Output {
        let body: Components.Schemas.WebSettingsUpdateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeEditSettings()
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
                homePageId: emptyToNil(body.homePageId ?? ""),
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
