import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import Foundation
import WebDomain
import WebModule

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
        return .ok(.init(body: .json(result.items.map(mapMenuItemListItem))))
    }

    private func mapMenuItemListItem(
        _ item: MenuItem.List.Output.Item
    ) -> Components.Schemas.MenuItemListItemSchema {
        .init(
            id: item.id,
            menuId: item.menuId,
            label: item.label,
            url: item.url,
            priority: item.priority,
            isBlank: item.isBlank,
            permission: item.permission,
            authentication: item.authentication.rawValue,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
