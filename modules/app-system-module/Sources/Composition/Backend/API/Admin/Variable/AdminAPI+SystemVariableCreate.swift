import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension SystemBackend {

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
    public func systemVariableCreate(
        _ input: Operations.SystemVariableCreate.Input
    ) async throws -> Operations.SystemVariableCreate.Output {

        let body: Components.Schemas.SystemVariableCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeAddVariable()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: body.id,
                value: body.value,
                name: body.name,
                notes: body.notes
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
