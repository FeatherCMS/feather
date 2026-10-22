import FeatherWebAdmin
import OpenAPIRuntime
import WebAdminAPI

struct AdminListWebMenuItemModel: Sendable {
    let items: [Components.Schemas.WebMenuItemQueryItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
