public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogTagPost(
        _ input: Operations.BlogTagPost.Input
    ) async throws -> Operations.BlogTagPost.Output {
        let body: Components.Schemas.TagPostSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                metadata: defaultBlogMetadata(
                    title: body.title,
                    excerpt: body.excerpt
                )
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
