import AccountAdminAPI
import AccountModule

extension Invitation.List {

    struct Model: Sendable {
        let items: [Components.Schemas.InvitationQuerySchemasItem]
        let total: Int
        let page: Int
        let pageSize: Int
    }
}
