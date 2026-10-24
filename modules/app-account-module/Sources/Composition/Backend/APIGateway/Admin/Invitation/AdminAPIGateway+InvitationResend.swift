public import AccountAdminAPI
import AccountApplication
import AccountModule
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func accountInvitationResend(
        _ input: Operations.AccountInvitationResend.Input
    ) async throws -> Operations.AccountInvitationResend.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeResendInvitation()
            .execute(
                subject: subject,
                input: .init(id: input.path.accountInvitationId)
            )
        return .ok(.init(body: .json(invitationDetailSchema(from: result))))
    }

    private func invitationDetailSchema(
        from output: Invitation.Resend.Output
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
