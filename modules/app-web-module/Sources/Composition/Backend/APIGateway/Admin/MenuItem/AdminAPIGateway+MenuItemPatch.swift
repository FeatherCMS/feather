import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication
import WebDomain

extension AdminAPIGateway {

    public func webMenuItemPatch(
        _ input: Operations.WebMenuItemPatch.Input
    ) async throws -> Operations.WebMenuItemPatch.Output {
        let body: Components.Schemas.WebMenuItemPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeEditMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webMenuItemId,
                menuId: input.path.webMenuId,
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                authentication: body.authentication.flatMap(
                    MenuItemAuthentication.init(rawValue:)
                ),
                notes: body.notes
            )
        )

        return .ok(.init(body: .json(useCases.map(result))))
    }
}
