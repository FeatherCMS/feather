import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMenuDelete(
        _ input: Operations.WebMenuDelete.Input
    ) async throws -> Operations.WebMenuDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.web.makeRemoveMenu()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webMenuId)
        )

        return .noContent(.init())
    }
}
