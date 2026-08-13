import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogAuthorCreate(
        _ input: Operations.BlogAuthorCreate.Input
    ) async throws -> Operations.BlogAuthorCreate.Output {
        let body: Components.Schemas.BlogAuthorCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeAddAuthor()
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
