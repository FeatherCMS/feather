import FeatherModuleKit
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
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                authentication: MenuItem.Authentication(
                    rawValue: body.authentication ?? "any"
                ) ?? .any,
                notes: body.notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
