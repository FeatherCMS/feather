import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userAccountUpdate(
        _ input: Operations.UserAccountUpdate.Input
    ) async throws -> Operations.UserAccountUpdate.Output {
        let body: Components.Schemas.UserAccountUpdateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeEditAccount()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.userAccountId,
                email: body.email,
                password: body.password,
                roleIds: body.roleIds,
                status: nil
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
