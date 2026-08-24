import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {
    public func blogSettingsUpdate(
        _ input: Operations.BlogSettingsUpdate.Input
    ) async throws -> Operations.BlogSettingsUpdate.Output {
        let body: Components.Schemas.BlogSettingsUpdateSchema
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
