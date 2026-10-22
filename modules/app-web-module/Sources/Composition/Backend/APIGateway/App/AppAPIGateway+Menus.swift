import FeatherModuleKit
public import WebAppAPI
import WebApplication
import WebModule

extension AppAPIGateway {
    public func menuList(
        _ input: Operations.MenuList.Input
    ) async throws -> Operations.MenuList.Output {
        let useCase = useCases.makeListPublicMenus()
        let result = try await useCase.execute(
            subject: await CurrentSubject.get()
        )

        return .ok(
            .init(
                body: .json(result.menus.map(mapPublicMenu))
            )
        )
    }

    public func menuGetByKey(
        _ input: Operations.MenuGetByKey.Input
    ) async throws -> Operations.MenuGetByKey.Output {
        let useCase = useCases.makeListPublicMenus()
        guard
            let result = try await useCase.execute(
                key: input.path.key,
                subject: await CurrentSubject.get()
            )
        else {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Menu not found",
                                reason: "No published menu exists for this key."
                            )
                        )
                    )
                )
            )
        }

        return .ok(
            .init(body: .json(mapPublicMenu(result)))
        )
    }
}
