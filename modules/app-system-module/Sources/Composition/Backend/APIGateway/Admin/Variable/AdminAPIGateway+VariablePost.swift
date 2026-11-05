import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    /// List system variables
    ///
    /// This functions list system variables. Example:
    /*
     curl -i -X 'POST' \
        'http://127.0.0.1:8080/api/v1/admin/system/variables' \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"name":"lorem","value":"ipsum","notes":"foobaripsum"}'
    */
    public func systemVariablePost(
        _ input: Operations.SystemVariablePost.Input
    ) async throws -> Operations.SystemVariablePost.Output {

        let body: Components.Schemas.SystemVariableCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddVariable()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                key: body.key,
                value: body.value,
                name: body.name,
                notes: body.notes
            )
        )

        return .created(
            .init(
                body: .json(variableDetailSchema(from: result))
            )
        )
    }

    private func variableDetailSchema(
        from output: Variable.Add.Output
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
