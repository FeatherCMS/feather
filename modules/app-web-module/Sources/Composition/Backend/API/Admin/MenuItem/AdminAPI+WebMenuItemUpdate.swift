import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication
import WebDomain

extension WebBackend {

    public func webMenuItemUpdate(
        _ input: Operations.WebMenuItemUpdate.Input
    ) async throws -> Operations.WebMenuItemUpdate.Output {
        let body: Components.Schemas.WebMenuItemCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = makeEditMenuItem()
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
                authentication: MenuItemAuthentication(
                    rawValue: body.authentication ?? "any"
                ) ?? .any,
                notes: body.notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
