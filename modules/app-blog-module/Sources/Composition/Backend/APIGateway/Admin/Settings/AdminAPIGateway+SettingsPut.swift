public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit

extension AdminAPIGateway {
    public func blogSettingsPut(
        _ input: Operations.BlogSettingsPut.Input
    ) async throws -> Operations.BlogSettingsPut.Output {
        let body: Components.Schemas.SettingsPutSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                postListPath: body.postListPath,
                authorListPath: body.authorListPath,
                tagListPath: body.tagListPath,
                postPathPrefix: body.postPathPrefix,
                authorPathPrefix: body.authorPathPrefix,
                tagPathPrefix: body.tagPathPrefix
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}

extension AdminAPIGateway {
    private func map(
        _ output: Settings.Edit.Output
    ) -> Components.Schemas.SettingsGetSchema {
        .init(
            postListPath: output.postListPath,
            authorListPath: output.authorListPath,
            tagListPath: output.tagListPath,
            postPathPrefix: output.postPathPrefix,
            authorPathPrefix: output.authorPathPrefix,
            tagPathPrefix: output.tagPathPrefix
        )
    }
}
