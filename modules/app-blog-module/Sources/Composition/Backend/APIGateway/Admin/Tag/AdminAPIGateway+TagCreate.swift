import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func blogTagCreate(
        _ input: Operations.BlogTagCreate.Input
    ) async throws -> Operations.BlogTagCreate.Output {
        let body: Components.Schemas.BlogTagCreateSchema
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
