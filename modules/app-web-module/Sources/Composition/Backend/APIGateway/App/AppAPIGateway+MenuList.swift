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
        return .ok(.init(body: .json(result.menus.map(mapPublicMenu))))
    }

    private func mapPublicMenu(
        _ menu: Menu.Public.List.Output.Menu
    ) -> Components.Schemas.MenuSchema {
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
