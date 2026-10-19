import SystemModule
import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication

extension AdminAPIGateway {

    public func systemVariableDelete(
        _ input: Operations.SystemVariableDelete.Input
    ) async throws -> Operations.SystemVariableDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeRemoveVariable()
        let subject = try await CurrentSubject.require()

        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
