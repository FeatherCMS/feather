public import AccountAdminAPI
import AccountApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func accountInvitationCreate(
        _ input: Operations.AccountInvitationCreate.Input
    ) async throws -> Operations.AccountInvitationCreate.Output {
        let body: Components.Schemas.InvitationPostSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeAddInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                email: body.email,
                roleIDs: body.roleIds ?? []
            )
        )

        return .created(
            .init(
                body: .json(invitationDetailSchema(from: result))
            )
        )
    }

    private func invitationDetailSchema(
        from output: Invitation.Add.Output
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
