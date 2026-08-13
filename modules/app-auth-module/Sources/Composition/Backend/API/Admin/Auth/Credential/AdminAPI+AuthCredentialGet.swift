import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AuthBackend {

    public func authCredentialGet(
        _ input: Operations.AuthCredentialGet.Input
    ) async throws -> Operations.AuthCredentialGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeGetCredential()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.authCredentialId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
