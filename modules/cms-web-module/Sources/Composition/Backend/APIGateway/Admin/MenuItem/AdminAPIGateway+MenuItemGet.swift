import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func menuItemGet(
        _ input: Operations.MenuItemGet.Input
    ) async throws -> Operations.MenuItemGet.Output {
        let useCase = useCases.makeDetailMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.menuItemId,
                menuId: input.path.menuId
            )
        )

        return .ok(.init(body: .json(mapMenuItemDetail(result))))
    }

    private func mapMenuItemDetail(
        _ detail: MenuItem.Detail.Output
    ) -> Components.Schemas.MenuItemDetailSchema {
        .init(
            id: detail.id,
            menuId: detail.menuId,
            label: detail.label,
            url: detail.url,
            priority: detail.priority,
            isBlank: detail.isBlank,
            permission: detail.permission,
            authentication: detail.authentication.rawValue,
            notes: detail.notes,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }
}
