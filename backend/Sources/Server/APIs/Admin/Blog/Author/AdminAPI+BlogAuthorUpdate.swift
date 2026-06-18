import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogAuthorUpdate(
        _ input: Operations.BlogAuthorUpdate.Input
    ) async throws -> Operations.BlogAuthorUpdate.Output {
        let body: Components.Schemas.BlogAuthorCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeEditAuthor()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorId,
                name: body.name,
                excerpt: body.excerpt,
                content: body.content,
                profileImageAssetId: .some(body.profileImageAssetId),
                metadata: mapBlogMetadata(body.metadata)
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
