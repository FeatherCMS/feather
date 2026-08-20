import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMenuDelete(
        _ input: Operations.WebMenuDelete.Input
    ) async throws -> Operations.WebMenuDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveMenu()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webMenuId)
        )

        return .noContent(.init())
    }
}
