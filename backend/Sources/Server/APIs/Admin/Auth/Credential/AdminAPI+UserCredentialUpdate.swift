import AdminOpenAPI
import Application
import AuthApplication

extension AdminAPI {

    func userCredentialUpdate(
        _ input: Operations.UserCredentialUpdate.Input
    ) async throws -> Operations.UserCredentialUpdate.Output {
        let body: Components.Schemas.UserCredentialCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeEditCredential()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.userCredentialId,
                email: body.email,
                password: body.password
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
