import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import Foundation
import WebModule

extension AdminAPIGateway {

    public func menuList(
        _ input: Operations.MenuList.Input
    ) async throws -> Operations.MenuList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListMenus()
            .execute(
                subject: subject,
                input: .init()
            )
        return .ok(.init(body: .json(result.items.map(mapMenuListItem))))
    }

    private func mapMenuListItem(
        _ item: Menu.List.Output.Item
    ) -> Components.Schemas.MenuListItemSchema {
        .init(
            id: item.id,
            key: item.key,
            name: item.name,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
