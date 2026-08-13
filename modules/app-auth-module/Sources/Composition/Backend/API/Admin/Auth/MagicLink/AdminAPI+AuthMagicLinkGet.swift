import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AuthBackend {

    public func authMagicLinkGet(
        _ input: Operations.AuthMagicLinkGet.Input
    ) async throws -> Operations.AuthMagicLinkGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeGetMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: GetMagicLink.Input(id: input.path.authMagicLinkId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
