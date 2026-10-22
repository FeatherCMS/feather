import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func menuItemPatch(
        _ input: Operations.MenuItemPatch.Input
    ) async throws -> Operations.MenuItemPatch.Output {
        let body: Components.Schemas.MenuItemPatchSchema
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
                authentication: body.authentication.flatMap(
                    MenuItem.Authentication.init(rawValue:)
                ),
                notes: body.notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
