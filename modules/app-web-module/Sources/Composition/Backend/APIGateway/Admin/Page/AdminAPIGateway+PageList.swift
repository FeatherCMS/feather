import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webPageList(
        _ input: Operations.WebPageList.Input
    ) async throws -> Operations.WebPageList.Output {
        let useCase = useCases.makeListPages()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )
        return .ok(
            .init(body: .json(result.items.map(mapList)))
        )
    }
}
