import AccountAdminAPI
import AccountApplication
import AccountModule
import Foundation

extension AdminAPIGateway {
    func invitationDetailSchema(
        from output: Invitation.Detail.Output
    ) -> Components.Schemas.InvitationSchemasDetail {
        invitationDetailSchema(
            id: output.id,
            email: output.email,
            token: output.token,
            roleIDs: output.roleIDs,
            expiresAt: output.expiresAt
        )
    }

    func invitationDetailSchema(
        from output: Invitation.Add.Output
    ) -> Components.Schemas.InvitationSchemasDetail {
        invitationDetailSchema(
            id: output.id,
            email: output.email,
            token: output.token,
            roleIDs: output.roleIDs,
            expiresAt: output.expiresAt
        )
    }

    func invitationDetailSchema(
        from output: Invitation.Edit.Output
    ) -> Components.Schemas.InvitationSchemasDetail {
        invitationDetailSchema(
            id: output.id,
            email: output.email,
            token: output.token,
            roleIDs: output.roleIDs,
            expiresAt: output.expiresAt
        )
    }

    func invitationDetailSchema(
        from output: Invitation.Resend.Output
    ) -> Components.Schemas.InvitationSchemasDetail {
        invitationDetailSchema(
            id: output.id,
            email: output.email,
            token: output.token,
            roleIDs: output.roleIDs,
            expiresAt: output.expiresAt
        )
    }

    private func invitationDetailSchema(
        id: String,
        email: String,
        token: String,
        roleIDs: [String],
        expiresAt: Date
    ) -> Components.Schemas.InvitationSchemasDetail {
        .init(
            id: id,
            email: email,
            token: token,
            roleIds: roleIDs,
            expiresAt: expiresAt.timeIntervalSince1970
        )
    }
}
