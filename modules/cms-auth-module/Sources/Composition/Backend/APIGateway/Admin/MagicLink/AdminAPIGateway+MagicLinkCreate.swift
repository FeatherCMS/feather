public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func authMagicLinkCreate(
        _ input: Operations.AuthMagicLinkCreate.Input
    ) async throws -> Operations.AuthMagicLinkCreate.Output {
        let body: Components.Schemas.AuthMagicLinkCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeAddMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                authEmailId: body.credentialId,
                isPersistent: body.isPersistent
            )
        )

        return .created(
            .init(
                body: .json(mapMagicLink(result))
            )
        )
    }
}

extension AdminAPIGateway {
    private func mapMagicLink(
        _ output: MagicLink.Add.Output
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
