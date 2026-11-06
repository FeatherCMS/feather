import FeatherWebAdmin
import OpenAPIRuntime
import WebAdminAPI
import WebDomain
import WebModule

extension WebModule.Menu.List {
    struct Model: Sendable {
        let items: [Components.Schemas.MenuQueryItemSchema]
        let total: Int
        let page: Int
        let pageSize: Int
    }
}
