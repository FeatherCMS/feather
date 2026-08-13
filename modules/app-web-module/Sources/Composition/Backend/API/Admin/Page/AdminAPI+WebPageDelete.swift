import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webPageDelete(
        _ input: Operations.WebPageDelete.Input
    ) async throws -> Operations.WebPageDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = makeRemovePage()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webPageId)
        )

        return .noContent(.init())
    }
}
