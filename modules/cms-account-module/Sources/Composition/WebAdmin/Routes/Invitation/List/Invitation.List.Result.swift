import AccountAdminAPI
import AccountModule

extension Invitation.List {
    struct Result: Sendable {
        let items: [Components.Schemas.InvitationQuerySchemasItem]
        let total: Int
        let page: Int
        let size: Int
    }
}
