public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogAuthorPost(
        _ input: Operations.BlogAuthorPost.Input
    ) async throws -> Operations.BlogAuthorPost.Output {
        let body: Components.Schemas.BlogAuthorCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddAuthor()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                name: body.name,
                excerpt: body.excerpt ?? "",
                content: body.content ?? "",
                profileImageAssetId: body.profileImageAssetId,
                metadata: defaultBlogMetadata(
                    title: body.name,
                    excerpt: body.excerpt ?? ""
                )
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
