public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherModuleKit

extension AdminAPIGateway {

    public func authCredentialGet(
        _ input: Operations.AuthCredentialGet.Input
    ) async throws -> Operations.AuthCredentialGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeGetCredential()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.authCredentialId)
        )

        return .ok(
            .init(
                body: .json(mapCredential(result))
            )
        )
    }
}

extension AdminAPIGateway {
    private func mapCredential(
        _ output: Credential.Detail.Output
    ) -> Components.Schemas.AuthCredentialDetailSchema {
        .init(id: output.id, userId: output.userId, email: output.email)
    }
}
