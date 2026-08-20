import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func blogTagDelete(
        _ input: Operations.BlogTagDelete.Input
    ) async throws -> Operations.BlogTagDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeRemoveTag()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogTagId)
        )

        return .noContent(.init())
    }
}
