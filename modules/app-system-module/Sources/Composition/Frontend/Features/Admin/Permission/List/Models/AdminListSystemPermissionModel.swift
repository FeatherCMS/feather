import FeatherAdmin
import Foundation
import SystemAdminAPI

struct AdminListSystemPermissionModel: Sendable {
    let items: [Components.Schemas.SystemPermissionListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
