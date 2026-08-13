import AccountAdminAPI
import FeatherAdmin
import Foundation

struct AdminListAccountInvitationModel: Sendable {
    let items: [Components.Schemas.AccountInvitationListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
