import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemVariableUpdate(
        _ input: Operations.SystemVariableUpdate.Input
    ) async throws -> Operations.SystemVariableUpdate.Output {
        let body: Components.Schemas.SystemVariableCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.system.makeEditVariable()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.systemVariableId,
                name: body.name,
                value: body.value,
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
