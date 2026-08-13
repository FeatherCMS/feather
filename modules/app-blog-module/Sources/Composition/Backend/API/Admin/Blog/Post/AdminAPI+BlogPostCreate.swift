import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogPostCreate(
        _ input: Operations.BlogPostCreate.Input
    ) async throws -> Operations.BlogPostCreate.Output {
        let body: Components.Schemas.BlogPostCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeAddPost()
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
                metadata: defaultBlogMetadata(
                    title: body.title,
                    excerpt: body.excerpt
                )
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
