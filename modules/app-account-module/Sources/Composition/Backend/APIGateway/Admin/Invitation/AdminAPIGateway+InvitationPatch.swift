public import AccountAdminAPI
import AccountApplication
import AccountModule
import FeatherModuleKit

extension AdminAPIGateway {

    public func accountInvitationPatch(
        _ input: Operations.AccountInvitationPatch.Input
    ) async throws -> Operations.AccountInvitationPatch.Output {
        let body: Components.Schemas.InvitationPatchSchema
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
                email: body.email,
                roleIDs: body.roleIds
            )
        )

        return .ok(
            .init(
                body: .json(invitationDetailSchema(from: result))
            )
        )
    }
}
