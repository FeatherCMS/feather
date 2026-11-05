public import AccountAdminAPI
import AccountApplication
import AccountModule
import FeatherDomain
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func accountInvitationUpdate(
        _ input: Operations.AccountInvitationUpdate.Input
    ) async throws -> Operations.AccountInvitationUpdate.Output {
        let body: Components.Schemas.InvitationPutSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeEditInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: Invitation.Edit.Input(
                id: input.path.accountInvitationId,
                email: .set(body.email),
                roleIDs: .set(body.roleIds ?? [])
            )
        )

        return .ok(
            .init(
                body: .json(invitationDetailSchema(from: result))
            )
        )
    }

    private func invitationDetailSchema(
        from output: Invitation.Edit.Output
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
