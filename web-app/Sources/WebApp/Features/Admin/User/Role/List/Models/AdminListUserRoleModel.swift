import AdminOpenAPI
import Foundation

struct AdminListUserRoleModel: Sendable {
    let items: [Components.Schemas.UserRoleListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
