import FeatherDomain
import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    public func systemVariablePut(
        _ input: Operations.SystemVariablePut.Input
    ) async throws -> Operations.SystemVariablePut.Output {
        let body: Components.Schemas.SystemVariableCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditVariable()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.systemVariableId,
                key: .set(body.key),
                value: .set(body.value),
                name: body.name.map { OptionalFieldChange.set($0) } ?? .clear,
                notes: body.notes.map { OptionalFieldChange.set($0) } ?? .clear
            )
        )

        return .ok(
            .init(
                body: .json(variableDetailSchema(from: result))
            )
        )
    }

    private func variableDetailSchema(
        from output: Variable.Edit.Output
    ) -> Components.Schemas.SystemVariableDetailSchema {
        .init(
            id: output.id,
            key: output.key,
            value: output.value,
            name: output.name,
            notes: output.notes
        )
    }
}
