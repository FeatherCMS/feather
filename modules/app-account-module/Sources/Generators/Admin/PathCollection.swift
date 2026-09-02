import AccountSharedOpenAPIGenerator
import FeatherOpenAPI
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/admin/account/settings": AccountSettingsPathItems(),
            "api/v1/admin/account/users/{userId}/profile":
                AdminAccountProfilePathItems(),
            "api/v1/admin/account/users/{userId}/settings":
                AdminAccountSettingsPathItems(),
            "api/v1/admin/account/invitations": AccountInvitationPathItems(),
            "api/v1/admin/account/invitations/":
                AccountInvitationListPathItems(),
            "api/v1/admin/account/invitations/search":
                AccountInvitationSearchPathItems(),
            "api/v1/admin/account/invitations/{accountInvitationId}":
                AccountInvitationIdPathItems(),
            "api/v1/admin/account/invitations/{accountInvitationId}/resend":
                AccountInvitationResendPathItems(),
        ]
    }
}
