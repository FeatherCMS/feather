import AdminOpenAPI
import Application
import AuthApplication

extension AdminAPI {

    func userCredentialCreate(
        _ input: Operations.UserCredentialCreate.Input
    ) async throws -> Operations.UserCredentialCreate.Output {
        let body: Components.Schemas.UserCredentialCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeAddCredential()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                accountID: body.accountID,
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
