import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication
import WebDomain

extension AdminAPIGateway {

    public func webMenuItemMove(
        _ input: Operations.WebMenuItemMove.Input
    ) async throws -> Operations.WebMenuItemMove.Output {
        let body: Components.Schemas.WebMenuItemMoveSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeMoveMenuItem()
        let subject = try await CurrentSubject.require()
        try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webMenuItemId,
                menuId: input.path.webMenuId,
                beforeItemId: body.beforeItemId.isEmpty
                    ? nil
                    : body.beforeItemId
            )
        )

        return .noContent(.init())
    }
}
