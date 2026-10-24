import FeatherDomain
import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import Foundation
import WebModule

extension AdminAPIGateway {

    public func menuUpdate(
        _ input: Operations.MenuUpdate.Input
    ) async throws -> Operations.MenuUpdate.Output {
        let body: Components.Schemas.MenuCreateSchema
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
                key: .set(body.key),
                name: .set(body.name),
                notes: .init(value: body.notes, shouldApply: true)
            )
        )

        return .ok(.init(body: .json(mapEditedMenu(result))))
    }

    func mapEditedMenu(
        _ output: Menu.Edit.Output
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
