import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/account/invitations": PathItem(),
                "api/v1/admin/account/invitations/query": Query.PathItem(),
                "api/v1/admin/account/invitations/{accountInvitationId}":
                    ID.PathItem(),
                "api/v1/admin/account/invitations/{accountInvitationId}/resend":
                    Resend.PathItem(),
            ]
        }
    }
}
