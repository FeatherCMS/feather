import FeatherContracts
public import WebAppAPI
import WebApplication

extension AppAPIGateway {
    public func webMenuList(
        _ input: Operations.WebMenuList.Input
    ) async throws -> Operations.WebMenuList.Output {
        let useCase = useCases.makeListPublicMenus()
        let result = try await useCase.execute(
            subject: await CurrentSubject.get()
        )

        return .ok(
            .init(
                body: .json(result.map(useCases.mapPublicMenu))
            )
        )
    }

    public func webMenuGetByKey(
        _ input: Operations.WebMenuGetByKey.Input
    ) async throws -> Operations.WebMenuGetByKey.Output {
        let useCase = useCases.makeListPublicMenus()
        guard
            let result = try await useCase.execute(
                key: input.path.key,
                subject: await CurrentSubject.get()
            )
        else {
            return .notFound
        }

        return .ok(
            .init(body: .json(useCases.mapPublicMenu(result)))
        )
    }
}
