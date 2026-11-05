public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit

extension AdminAPIGateway {
    public func blogSettingsGet(
        _ input: Operations.BlogSettingsGet.Input
    ) async throws -> Operations.BlogSettingsGet.Output {
        let useCase = self.useCases.makeDetailSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )

        return .ok(.init(body: .json(map(result))))
    }
}

extension AdminAPIGateway {
    private func map(
        _ output: Settings.Detail.Output
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
