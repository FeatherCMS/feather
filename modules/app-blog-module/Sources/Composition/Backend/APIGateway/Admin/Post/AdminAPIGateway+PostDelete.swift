import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func blogPostDelete(
        _ input: Operations.BlogPostDelete.Input
    ) async throws -> Operations.BlogPostDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeRemovePost()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogPostId)
        )

        return .noContent(.init())
    }
}
