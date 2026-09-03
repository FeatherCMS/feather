import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func authMagicLinkPatch(
        _ input: Operations.AuthMagicLinkPatch.Input
    ) async throws -> Operations.AuthMagicLinkPatch.Output {
        let body: Components.Schemas.AuthMagicLinkPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeEditMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: AuthApplication.EditMagicLink.Input(
                id: input.path.authMagicLinkId,
                identityEmailId: body.credentialId,
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
