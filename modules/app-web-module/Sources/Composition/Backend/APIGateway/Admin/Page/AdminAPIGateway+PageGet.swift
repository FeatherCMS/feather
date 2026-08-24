import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webPageGet(
        _ input: Operations.WebPageGet.Input
    ) async throws -> Operations.WebPageGet.Output {
        let useCase = useCases.makeGetPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webPageId)
        )

        return .ok(.init(body: .json(useCases.map(result))))
    }
}
