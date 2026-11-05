import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Search {
    struct Model: Sendable {
        let items: [Item]
        let total: Int
        let page: Int
        let pageSize: Int
    }
}
