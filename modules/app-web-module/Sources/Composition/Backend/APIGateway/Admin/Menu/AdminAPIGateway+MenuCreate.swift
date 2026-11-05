import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebModule

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

        return .created(.init(body: .json(mapAddedMenu(result))))
    }

    private func mapAddedMenu(
        _ output: Menu.Add.Output
    ) -> Components.Schemas.MenuDetailSchema {
        .init(
            id: output.id,
            key: output.key,
            name: output.name,
            notes: output.notes,
            createdAt: output.createdAt.timeIntervalSince1970,
            updatedAt: output.updatedAt.timeIntervalSince1970
        )
    }
}
