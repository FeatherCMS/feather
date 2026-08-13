import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogPostGet(
        _ input: Operations.BlogPostGet.Input
    ) async throws -> Operations.BlogPostGet.Output {
        let useCase = self.makeGetPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogPostId)
        )

        return .ok(.init(body: .json(map(result))))
    }
}
