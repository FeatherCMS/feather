public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherDomain
import FeatherModuleKit
import Foundation

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
                authEmailId: .set(body.credentialId),
                isPersistent: .set(body.isPersistent)
            )
        )

        return .ok(
            .init(
                body: .json(mapMagicLink(result))
            )
        )
    }
}

extension AdminAPIGateway {
    private func mapMagicLink(
        _ output: MagicLink.Edit.Output
    ) -> Components.Schemas.AuthMagicLinkDetailSchema {
        .init(
            id: output.id,
            credentialId: output.authEmailId,
            token: output.token,
            expiresAt: output.expiresAt.timeIntervalSince1970,
            isPersistent: output.isPersistent,
            isUsed: output.isUsed
        )
    }
}
