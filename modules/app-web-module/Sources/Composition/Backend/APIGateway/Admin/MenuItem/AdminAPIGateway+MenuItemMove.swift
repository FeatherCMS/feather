import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func menuItemMove(
        _ input: Operations.MenuItemMove.Input
    ) async throws -> Operations.MenuItemMove.Output {
        let body: Components.Schemas.MenuItemMoveSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeMoveMenuItem()
        let subject = try await CurrentSubject.require()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.menuItemId,
                menuId: input.path.menuId,
                beforeItemId: body.beforeItemId.isEmpty
                    ? nil
                    : body.beforeItemId
            )
        )

        return .noContent(.init())
    }
}
