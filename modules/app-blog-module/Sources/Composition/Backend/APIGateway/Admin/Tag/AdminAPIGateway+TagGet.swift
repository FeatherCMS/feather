import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func blogTagGet(
        _ input: Operations.BlogTagGet.Input
    ) async throws -> Operations.BlogTagGet.Output {
        let useCase = self.useCases.makeGetTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogTagId)
        )

        return .ok(.init(body: .json(map(result))))
    }
}
