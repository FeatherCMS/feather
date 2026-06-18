import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userAccountCreate(
        _ input: Operations.UserAccountCreate.Input
    ) async throws -> Operations.UserAccountCreate.Output {
        let body: Components.Schemas.UserAccountCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeAddAccount()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                email: body.email,
                password: body.password
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
