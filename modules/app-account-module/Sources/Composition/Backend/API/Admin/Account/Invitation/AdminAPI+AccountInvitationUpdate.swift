import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AccountBackend {

    public func accountInvitationUpdate(
        _ input: Operations.AccountInvitationUpdate.Input
    ) async throws -> Operations.AccountInvitationUpdate.Output {
        let body: Components.Schemas.AccountInvitationCreateSchema
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
