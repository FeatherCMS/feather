import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AuthBackend {

    public func authCredentialPatch(
        _ input: Operations.AuthCredentialPatch.Input
    ) async throws -> Operations.AuthCredentialPatch.Output {
        let body: Components.Schemas.AuthCredentialPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.makeEditCredential()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.authCredentialId,
                email: body.email,
                password: body.password,
                isPersistent: body.isPersistent
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
