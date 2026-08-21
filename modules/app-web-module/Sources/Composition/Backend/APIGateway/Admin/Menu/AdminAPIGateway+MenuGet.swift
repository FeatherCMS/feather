import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMenuGet(
        _ input: Operations.WebMenuGet.Input
    ) async throws -> Operations.WebMenuGet.Output {
        let useCase = useCases.makeGetMenu()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webMenuId)
        )

        return .ok(.init(body: .json(useCases.map(result))))
    }
}
