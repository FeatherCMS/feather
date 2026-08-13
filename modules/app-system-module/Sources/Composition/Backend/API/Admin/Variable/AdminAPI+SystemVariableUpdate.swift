import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension SystemBackend {

    public func systemVariableUpdate(
        _ input: Operations.SystemVariableUpdate.Input
    ) async throws -> Operations.SystemVariableUpdate.Output {
        let body: Components.Schemas.SystemVariableCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeEditVariable()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.systemVariableId,
                value: body.value,
                name: body.name,
                notes: body.notes
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
