import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogTagCreate(
        _ input: Operations.BlogTagCreate.Input
    ) async throws -> Operations.BlogTagCreate.Output {
        let body: Components.Schemas.BlogTagCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeAddTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                metadata: mapBlogMetadata(body.metadata)
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
