import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AccountBackend {

    public func accountInvitationCreate(
        _ input: Operations.AccountInvitationCreate.Input
    ) async throws -> Operations.AccountInvitationCreate.Output {
        let body: Components.Schemas.AccountInvitationCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = makeAddInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                email: body.email,
                roleIDs: body.roleIds ?? []
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
