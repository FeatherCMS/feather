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

    private func mapPublicMenu(
        _ menu: Menu.Public.List.Output.Menu
    ) -> WebAppAPI.Components.Schemas.MenuSchema {
        .init(
            id: menu.id,
            key: menu.key,
            name: menu.name,
            items: menu.items.map {
                .init(
                    id: $0.id,
                    label: $0.label,
                    url: $0.url,
                    priority: $0.priority,
                    isBlank: $0.isBlank
                )
            }
        )
    }
}
