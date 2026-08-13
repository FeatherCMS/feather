import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogPostUpdate(
        _ input: Operations.BlogPostUpdate.Input
    ) async throws -> Operations.BlogPostUpdate.Output {
        let body: Components.Schemas.BlogPostPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeEditPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogPostId,
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                authorIds: Array(body.authorIds ?? []),
                tagIds: Array(body.tagIds ?? []),
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
