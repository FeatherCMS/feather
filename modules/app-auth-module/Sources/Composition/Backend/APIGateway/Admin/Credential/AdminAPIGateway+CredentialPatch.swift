import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func authCredentialPatch(
        _ input: Operations.AuthCredentialPatch.Input
    ) async throws -> Operations.AuthCredentialPatch.Output {
        let body: Components.Schemas.AuthCredentialPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeEditCredential()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.authCredentialId,
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
