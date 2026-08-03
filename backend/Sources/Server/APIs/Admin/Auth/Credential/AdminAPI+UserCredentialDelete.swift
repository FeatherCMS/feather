import AdminOpenAPI
import Application
import AuthApplication

extension AdminAPI {

    func userCredentialDelete(
        _ input: Operations.UserCredentialDelete.Input
    ) async throws -> Operations.UserCredentialDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeRemoveCredential()
        let deleted = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userCredentialId)
        )

        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
