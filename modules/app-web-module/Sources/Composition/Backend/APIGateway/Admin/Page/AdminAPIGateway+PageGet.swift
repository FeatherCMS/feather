import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func pageGet(
        _ input: Operations.PageGet.Input
    ) async throws -> Operations.PageGet.Output {
        let useCase = useCases.makePageDetail()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.pageId)
        )

        return .ok(.init(body: .json(map(result))))
    }
}
