import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMenuItemDelete(
        _ input: Operations.WebMenuItemDelete.Input
    ) async throws -> Operations.WebMenuItemDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.web.makeRemoveMenuItem()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webMenuItemId,
                menuId: input.path.webMenuId
            )
        )

        return .noContent(.init())
    }
}
