import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func menuItemList(
        _ input: Operations.MenuItemList.Input
    ) async throws -> Operations.MenuItemList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListMenuItems()
            .execute(
                subject: subject,
                input: .init(menuId: input.path.menuId)
            )
        return .ok(.init(body: .json(result.items.map(mapList))))
    }
}
