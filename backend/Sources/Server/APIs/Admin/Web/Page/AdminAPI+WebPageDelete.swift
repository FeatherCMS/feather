import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webPageDelete(
        _ input: Operations.WebPageDelete.Input
    ) async throws -> Operations.WebPageDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.web.makeRemovePage()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webPageId)
        )

        return .noContent(.init())
    }
}
