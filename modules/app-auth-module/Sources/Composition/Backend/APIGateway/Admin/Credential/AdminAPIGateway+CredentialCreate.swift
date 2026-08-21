import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func authCredentialCreate(
        _ input: Operations.AuthCredentialCreate.Input
    ) async throws -> Operations.AuthCredentialCreate.Output {
        let body: Components.Schemas.AuthCredentialCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeAddCredential()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                userId: body.userId,
                email: body.email,
                password: body.password,
                isPersistent: body.isPersistent
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
