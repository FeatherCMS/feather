import AccountAdminAPI
import AccountApplication
import AccountModule
import Foundation

extension AdminAPIGateway {
    func invitationDetailSchema(
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
