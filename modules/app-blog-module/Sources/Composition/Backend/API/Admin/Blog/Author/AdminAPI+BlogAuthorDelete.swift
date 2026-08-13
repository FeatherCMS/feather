import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogAuthorDelete(
        _ input: Operations.BlogAuthorDelete.Input
    ) async throws -> Operations.BlogAuthorDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeRemoveAuthor()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogAuthorId)
        )

        return .noContent(.init())
    }
}
