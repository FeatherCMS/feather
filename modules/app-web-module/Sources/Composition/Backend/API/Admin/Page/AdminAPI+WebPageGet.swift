import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webPageGet(
        _ input: Operations.WebPageGet.Input
    ) async throws -> Operations.WebPageGet.Output {
        let useCase = makeGetPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webPageId)
        )

        return .ok(.init(body: .json(map(result))))
    }
}
