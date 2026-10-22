import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func menuCreate(
        _ input: Operations.MenuCreate.Input
    ) async throws -> Operations.MenuCreate.Output {
        let body: Components.Schemas.MenuCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeAddMenu()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                key: body.key,
                name: body.name,
                notes: body.notes ?? ""
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
