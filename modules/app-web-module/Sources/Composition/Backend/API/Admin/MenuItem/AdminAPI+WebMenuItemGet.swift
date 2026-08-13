import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webMenuItemGet(
        _ input: Operations.WebMenuItemGet.Input
    ) async throws -> Operations.WebMenuItemGet.Output {
        let useCase = makeGetMenuItem()
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
