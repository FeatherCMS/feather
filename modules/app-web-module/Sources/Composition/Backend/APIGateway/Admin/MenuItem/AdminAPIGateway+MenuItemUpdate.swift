import FeatherDomain
import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func menuItemUpdate(
        _ input: Operations.MenuItemUpdate.Input
    ) async throws -> Operations.MenuItemUpdate.Output {
        let body: Components.Schemas.MenuItemCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeEditMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.menuItemId,
                menuId: input.path.menuId,
                label: .set(body.label),
                url: .set(body.url),
                priority: .set(body.priority),
                isBlank: .set(body.isBlank),
                permission: .set(body.permission),
                authentication: .set(
                    MenuItem.Model.Authentication(
                        rawValue: body.authentication ?? "any"
                    ) ?? .any
                ),
                notes: .init(value: body.notes, shouldApply: true)
            )
        )

        return .ok(.init(body: .json(mapEditedMenuItem(result))))
    }

    func mapEditedMenuItem(
        _ output: MenuItem.Edit.Output
    ) -> Components.Schemas.MenuItemDetailSchema {
        .init(
            id: output.id,
            menuId: output.menuId,
            label: output.label,
            url: output.url,
            priority: output.priority,
            isBlank: output.isBlank,
            permission: output.permission,
            authentication: output.authentication.rawValue,
            notes: output.notes,
            createdAt: output.createdAt.timeIntervalSince1970,
            updatedAt: output.updatedAt.timeIntervalSince1970
        )
    }
}
