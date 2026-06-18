import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userRoleUpdate(
        _ input: Operations.UserRoleUpdate.Input
    ) async throws -> Operations.UserRoleUpdate.Output {
        let body: Components.Schemas.UserRoleCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeEditRole()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.userRoleId,
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
