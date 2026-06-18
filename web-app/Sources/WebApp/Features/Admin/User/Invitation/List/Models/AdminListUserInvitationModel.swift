import AdminOpenAPI
import Foundation

struct AdminListUserInvitationModel: Sendable {
    let items: [Components.Schemas.UserInvitationListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
