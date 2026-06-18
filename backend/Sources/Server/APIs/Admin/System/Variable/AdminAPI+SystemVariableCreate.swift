import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

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
    func systemVariableCreate(
        _ input: Operations.SystemVariableCreate.Input
    ) async throws -> Operations.SystemVariableCreate.Output {

        let body: Components.Schemas.SystemVariableCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.system.makeAddVariable()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                name: body.name,
                value: body.value,
                notes: body.notes ?? ""
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
