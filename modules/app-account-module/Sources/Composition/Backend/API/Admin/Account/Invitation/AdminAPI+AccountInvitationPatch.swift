import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AccountBackend {

    public func accountInvitationPatch(
        _ input: Operations.AccountInvitationPatch.Input
    ) async throws -> Operations.AccountInvitationPatch.Output {
        let body: Components.Schemas.AccountInvitationPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = makeEditInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: AccountApplication.EditInvitation.Input(
                id: input.path.accountInvitationId,
                email: body.email
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
