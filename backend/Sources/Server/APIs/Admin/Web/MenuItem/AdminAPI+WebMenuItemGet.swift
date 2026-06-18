import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMenuItemGet(
        _ input: Operations.WebMenuItemGet.Input
    ) async throws -> Operations.WebMenuItemGet.Output {
        let useCase = modules.web.makeGetMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webMenuItemId,
                menuId: input.path.webMenuId
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
