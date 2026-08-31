import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func accountInvitationPatch(
        _ input: Operations.AccountInvitationPatch.Input
    ) async throws -> Operations.AccountInvitationPatch.Output {
        let body: Components.Schemas.AccountInvitationPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeEditInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: AccountApplication.EditInvitation.Input(
                id: input.path.accountInvitationId,
                email: body.email,
                roleIDs: body.roleIds
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
