import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func menuItemGet(
        _ input: Operations.MenuItemGet.Input
    ) async throws -> Operations.MenuItemGet.Output {
        let useCase = useCases.makeGetMenuItem()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.menuItemId,
                menuId: input.path.menuId
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
