import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogAuthorGet(
        _ input: Operations.BlogAuthorGet.Input
    ) async throws -> Operations.BlogAuthorGet.Output {
        let useCase = self.makeGetAuthor()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogAuthorId)
        )

        return .ok(.init(body: .json(map(result))))
    }
}
