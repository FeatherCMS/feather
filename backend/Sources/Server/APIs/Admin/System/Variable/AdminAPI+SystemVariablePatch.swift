import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemVariablePatch(
        _ input: Operations.SystemVariablePatch.Input
    ) async throws -> Operations.SystemVariablePatch.Output {
        let body: Components.Schemas.SystemVariablePatchSchema
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
