import FeatherWebAdmin
import OpenAPIRuntime
import WebAdminAPI

struct AdminListMenuItemModel: Sendable {
    let items: [Components.Schemas.MenuItemQueryItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
