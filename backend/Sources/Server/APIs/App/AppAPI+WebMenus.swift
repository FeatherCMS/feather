import Application
import AppOpenAPI
import WebApplication

extension AppAPI {
    func webMenuList(
        _ input: Operations.WebMenuList.Input
    ) async throws -> Operations.WebMenuList.Output {
        let useCase = modules.web.makeListPublicMenus()
        let result = try await useCase.execute(
            subject: await CurrentSubject.get()
        )

        return .ok(
            .init(
                body: .json(result.map(mapPublicMenu))
            )
        )
    }
}
