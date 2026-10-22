import FeatherWebAdmin
import OpenAPIRuntime
import WebAdminAPI
import WebDomain

extension Menu.List {
    struct Model: Sendable {
        let items: [Components.Schemas.WebMenuQueryItemSchema]
        let total: Int
        let page: Int
        let pageSize: Int
    }
}
