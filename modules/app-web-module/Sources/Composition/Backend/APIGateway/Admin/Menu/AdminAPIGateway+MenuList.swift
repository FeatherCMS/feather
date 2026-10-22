import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMenuList(
        _ input: Operations.WebMenuList.Input
    ) async throws -> Operations.WebMenuList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListMenus()
            .execute(
                subject: subject,
                input: .init()
            )
        return .ok(.init(body: .json(result.items.map(useCases.mapList))))
    }
}
