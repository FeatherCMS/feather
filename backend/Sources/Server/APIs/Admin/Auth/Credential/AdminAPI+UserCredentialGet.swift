import AdminOpenAPI
import Application
import AuthApplication

extension AdminAPI {

    func userCredentialGet(
        _ input: Operations.UserCredentialGet.Input
    ) async throws -> Operations.UserCredentialGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeGetCredential()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.userCredentialId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
