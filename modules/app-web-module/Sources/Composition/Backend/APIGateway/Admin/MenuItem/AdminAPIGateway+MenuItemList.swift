import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMenuItemList(
        _ input: Operations.WebMenuItemList.Input
    ) async throws -> Operations.WebMenuItemList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListMenuItems()
            .execute(
                subject: subject,
                input: .init(menuId: input.path.webMenuId)
            )
        return .ok(.init(body: .json(result.items.map(useCases.mapList))))
    }
}
