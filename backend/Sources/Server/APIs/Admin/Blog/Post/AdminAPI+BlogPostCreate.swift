import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogPostCreate(
        _ input: Operations.BlogPostCreate.Input
    ) async throws -> Operations.BlogPostCreate.Output {
        let body: Components.Schemas.BlogPostCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeAddPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                authorIds: Array(body.authorIds ?? []),
                tagIds: Array(body.tagIds ?? []),
                metadata: mapBlogMetadata(body.metadata)
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
