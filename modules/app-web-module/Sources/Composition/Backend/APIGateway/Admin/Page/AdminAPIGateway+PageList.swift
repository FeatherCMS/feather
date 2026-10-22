import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func pageList(
        _ input: Operations.PageList.Input
    ) async throws -> Operations.PageList.Output {
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
