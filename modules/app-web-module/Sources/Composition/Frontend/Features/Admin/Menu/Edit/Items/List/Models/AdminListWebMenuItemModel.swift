import FeatherAdmin
import Foundation
import OpenAPIRuntime
import WebAdminAPI

struct AdminListWebMenuItemModel: Sendable {
    let items: [Components.Schemas.WebMenuItemListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
