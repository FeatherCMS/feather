public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherModuleKit

extension AdminAPIGateway {

    public func authMagicLinkUpdate(
        _ input: Operations.AuthMagicLinkUpdate.Input
    ) async throws -> Operations.AuthMagicLinkUpdate.Output {
        let body: Components.Schemas.AuthMagicLinkCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeEditMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: MagicLink.Edit.Input(
                id: input.path.authMagicLinkId,
                authEmailId: body.credentialId,
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
