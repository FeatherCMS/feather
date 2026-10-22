import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func menuPatch(
        _ input: Operations.MenuPatch.Input
    ) async throws -> Operations.MenuPatch.Output {
        let body: Components.Schemas.MenuPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeEditMenu()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.menuId,
                key: body.key,
                name: body.name,
                notes: body.notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
