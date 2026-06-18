import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userRoleCreate(
        _ input: Operations.UserRoleCreate.Input
    ) async throws -> Operations.UserRoleCreate.Output {
        let body: Components.Schemas.UserRoleCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeAddRole()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                name: body.name,
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
