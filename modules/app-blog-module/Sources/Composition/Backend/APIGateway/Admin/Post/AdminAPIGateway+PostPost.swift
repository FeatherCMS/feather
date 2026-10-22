public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogPostPost(
        _ input: Operations.BlogPostPost.Input
    ) async throws -> Operations.BlogPostPost.Output {
        let body: Components.Schemas.PostPostSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddPost()
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
