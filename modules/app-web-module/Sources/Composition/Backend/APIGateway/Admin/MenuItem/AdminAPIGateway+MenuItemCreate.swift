import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication
import WebDomain

extension AdminAPIGateway {

    public func webMenuItemCreate(
        _ input: Operations.WebMenuItemCreate.Input
    ) async throws -> Operations.WebMenuItemCreate.Output {
        let body: Components.Schemas.WebMenuItemCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeAddMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                menuId: input.path.webMenuId,
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                authentication: MenuItemAuthentication(
                    rawValue: body.authentication ?? "any"
                ) ?? .any,
                notes: body.notes ?? ""
            )
        )

        return .created(.init(body: .json(useCases.map(result))))
    }
}
