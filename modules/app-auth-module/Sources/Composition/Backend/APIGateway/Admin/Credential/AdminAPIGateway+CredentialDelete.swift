import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func authCredentialDelete(
        _ input: Operations.AuthCredentialDelete.Input
    ) async throws -> Operations.AuthCredentialDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeRemoveCredential()
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
