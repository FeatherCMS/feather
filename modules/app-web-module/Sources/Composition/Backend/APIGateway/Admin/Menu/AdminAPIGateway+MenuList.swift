import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func menuList(
        _ input: Operations.MenuList.Input
    ) async throws -> Operations.MenuList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListMenus()
            .execute(
                subject: subject,
                input: .init()
            )
        return .ok(.init(body: .json(result.items.map(mapList))))
    }
}
