import AccountSharedOpenAPIGenerator
import FeatherOpenAPI
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/admin/account/settings": AccountSettingsPathItems(),
            "api/v1/admin/account/invitations": AccountInvitationPathItems(),
            "api/v1/admin/account/invitations/filters":
                AccountInvitationFiltersPathItems(),
            "api/v1/admin/account/invitations/search":
                AccountInvitationSearchPathItems(),
            "api/v1/admin/account/invitations/{accountInvitationId}":
                AccountInvitationIdPathItems(),
        ]
    }
}
