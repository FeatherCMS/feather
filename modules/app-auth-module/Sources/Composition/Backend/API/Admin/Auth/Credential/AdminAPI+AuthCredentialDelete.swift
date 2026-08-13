import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AuthBackend {

    public func authCredentialDelete(
        _ input: Operations.AuthCredentialDelete.Input
    ) async throws -> Operations.AuthCredentialDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeRemoveCredential()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.authCredentialId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
