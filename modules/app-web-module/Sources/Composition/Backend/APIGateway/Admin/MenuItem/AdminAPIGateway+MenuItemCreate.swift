import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import Foundation
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func menuItemCreate(
        _ input: Operations.MenuItemCreate.Input
    ) async throws -> Operations.MenuItemCreate.Output {
        let body: Components.Schemas.MenuItemCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeAddMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                menuId: input.path.menuId,
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                authentication: MenuItem.Model.Authentication(
                    rawValue: body.authentication ?? "any"
                ) ?? .any,
                notes: body.notes ?? ""
            )
        )

        return .created(.init(body: .json(mapAddedMenuItem(result))))
    }

    private func mapAddedMenuItem(
        _ output: MenuItem.Add.Output
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
