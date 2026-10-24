public import AccountAdminAPI
import AccountApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func accountInvitationGet(
        _ input: Operations.AccountInvitationGet.Input
    ) async throws -> Operations.AccountInvitationGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeGetInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.accountInvitationId)
        )

        return .ok(
            .init(
                body: .json(invitationDetailSchema(from: result))
            )
        )
    }

    private func invitationDetailSchema(
        from output: Invitation.Detail.Output
    ) -> Components.Schemas.InvitationSchemasDetail {
        .init(
            id: output.id,
            email: output.email,
            token: output.token,
            roleIds: output.roleIDs,
            expiresAt: output.expiresAt.timeIntervalSince1970
        )
    }
}
