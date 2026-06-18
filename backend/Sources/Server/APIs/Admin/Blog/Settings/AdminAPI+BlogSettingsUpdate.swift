import Application
import BlogApplication
import AdminOpenAPI

extension AdminAPI {
    func blogSettingsUpdate(
        _ input: Operations.BlogSettingsUpdate.Input
    ) async throws -> Operations.BlogSettingsUpdate.Output {
        let body: Components.Schemas.BlogSettingsUpdateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeEditSettings()
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
