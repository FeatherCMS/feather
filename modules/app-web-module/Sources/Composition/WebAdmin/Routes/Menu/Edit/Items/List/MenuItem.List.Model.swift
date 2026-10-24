import FeatherWebAdmin
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension MenuItem.List {
    struct Model: Sendable {
        let items: [Components.Schemas.MenuItemQueryItemSchema]
        let total: Int
        let page: Int
        let pageSize: Int
    }
}
