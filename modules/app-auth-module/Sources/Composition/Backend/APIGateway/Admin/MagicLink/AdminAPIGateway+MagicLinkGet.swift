public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func authMagicLinkGet(
        _ input: Operations.AuthMagicLinkGet.Input
    ) async throws -> Operations.AuthMagicLinkGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeDetailMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: MagicLink.Detail.Input(id: input.path.authMagicLinkId)
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
        _ output: MagicLink.Detail.Output
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
