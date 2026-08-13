import FeatherApplication
import FeatherContracts
import WebAppAPI
import WebApplication

extension WebBackend {
    public func webMenuList(
        _ input: Operations.WebMenuList.Input
    ) async throws -> Operations.WebMenuList.Output {
        let useCase = makeListPublicMenus()
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
