import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogTagUpdate(
        _ input: Operations.BlogTagUpdate.Input
    ) async throws -> Operations.BlogTagUpdate.Output {
        let body: Components.Schemas.BlogTagCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeEditTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogTagId,
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: .some(body.imageAssetId),
                metadata: mapBlogMetadata(body.metadata)
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
