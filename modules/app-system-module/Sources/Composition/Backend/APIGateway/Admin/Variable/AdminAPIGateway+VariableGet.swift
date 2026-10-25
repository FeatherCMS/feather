import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    public func systemVariableGet(
        _ input: Operations.SystemVariableGet.Input
    ) async throws -> Operations.SystemVariableGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeDetailVariable()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.systemVariableId)
        )

        return .ok(
            .init(
                body: .json(variableDetailSchema(from: result))
            )
        )
    }

    private func variableDetailSchema(
        from output: Variable.Detail.Output
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
