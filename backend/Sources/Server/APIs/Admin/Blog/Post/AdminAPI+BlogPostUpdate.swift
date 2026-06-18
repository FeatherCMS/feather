import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogPostUpdate(
        _ input: Operations.BlogPostUpdate.Input
    ) async throws -> Operations.BlogPostUpdate.Output {
        let body: Components.Schemas.BlogPostCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeEditPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogPostId,
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: .some(body.imageAssetId),
                authorIds: Array(body.authorIds ?? []),
                tagIds: Array(body.tagIds ?? []),
                metadata: mapBlogMetadata(body.metadata)
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
