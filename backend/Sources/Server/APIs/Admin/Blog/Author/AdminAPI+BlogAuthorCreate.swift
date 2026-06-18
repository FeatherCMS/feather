import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogAuthorCreate(
        _ input: Operations.BlogAuthorCreate.Input
    ) async throws -> Operations.BlogAuthorCreate.Output {
        let body: Components.Schemas.BlogAuthorCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeAddAuthor()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                name: body.name,
                excerpt: body.excerpt ?? "",
                content: body.content ?? "",
                profileImageAssetId: body.profileImageAssetId,
                metadata: mapBlogMetadata(body.metadata)
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
