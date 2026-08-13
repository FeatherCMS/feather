import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogAuthorLinkDelete(
        _ input: Operations.BlogAuthorLinkDelete.Input
    ) async throws -> Operations.BlogAuthorLinkDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeRemoveAuthorLink()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorLinkId,
                authorId: input.path.blogAuthorId
            )
        )

        return .noContent(.init())
    }
}
