import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func menuGet(
        _ input: Operations.MenuGet.Input
    ) async throws -> Operations.MenuGet.Output {
        let useCase = useCases.makeGetMenu()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.menuId)
        )

        return .ok(.init(body: .json(map(result))))
    }
}
